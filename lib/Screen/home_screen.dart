import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/Model/ai_model.dart';
import 'package:flutter_ai_app/Screen/chat_view_widget.dart';
import 'package:flutter_ai_app/Screen/input_field_widget.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final gemini = Gemini.instance;
  final ImagePicker imagePicker = ImagePicker();
  List<Uint8List> images = [];
  List<AIModel> aiModel = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Flutter AI"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Expanded(
              child: Visibility(
                visible: aiModel.isNotEmpty,
                replacement: const Center(
                  child: Text(
                    "How can I help you Today?",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                child: SingleChildScrollView(
                  reverse: true,
                  child: ListView.separated(
                    itemCount: aiModel.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, i) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return ChatViewWidget(aiModel: aiModel[index]);
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isLoading,
              child: const SizedBox(
                height: 50,
                child: LoadingIndicator(
                    indicatorType: Indicator.ballPulseSync,
                    colors: [Colors.purple],
                    strokeWidth: 2,
                    pathBackgroundColor: Colors.purple),
              ),
            ),
            InputFieldWidget(
              //search
              searchController: searchController,
              //image
              images: images,
              //selectImage
              selectImage: () async {
                final List<XFile> file = await imagePicker.pickMultiImage();
                if (file.isNotEmpty) {
                  for (final img in file) {
                    images.add(await img.readAsBytes());
                    setState(() {});
                  }
                }
              },
              //sendPrompt
              onSend: () {
                aiModel.add(AIModel(
                    isUser: true,
                    text: searchController.text.toString(),
                    images: images));

                String text = searchController.text.toString();
                isLoading = true;
                List<Uint8List> img = images;

                images = [];
                searchController.clear();

                setState(() {
                  gemini
                      .streamGenerateContent(text, images: img)
                      .listen((value) {
                    if (aiModel.last.isUser == true) {
                      aiModel.add(AIModel(
                        isUser: false,
                        text: value.output,
                      ));
                    }

                    aiModel.last.text = "${aiModel.last.text}${value.output}";
                    isLoading = false;

                    setState(() {});
                  }).onError((e) {
                    log('streamGenerateContent exception', error: e);
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
