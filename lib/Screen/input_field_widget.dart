import 'package:flutter/material.dart';
import 'dart:typed_data';

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget({
    super.key,
    required this.searchController,
    required this.selectImage,
    required this.onSend,
    required this.images,
  });

  final TextEditingController searchController;
  final VoidCallback selectImage, onSend;
  final List<Uint8List> images;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          //It's appear when images selected
          Visibility(
            visible: images.isNotEmpty,
            child: SizedBox(
              height: 120,
              child: ListView.separated(
                separatorBuilder: (context, i) => const SizedBox(width: 5),
                itemCount: images.length,
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(
                          images[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Row(
            children: [
              // Image Picker
              IconButton(
                onPressed: selectImage,
                icon: const Icon(Icons.image),
              ),

              //TextField
              Expanded(
                child: TextField(
                  controller: searchController,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Enter a prompt here",
                    border: InputBorder.none,
                  ),
                ),
              ),

              // Send
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: onSend,
                  icon: const Icon(Icons.send),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
