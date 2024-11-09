import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../Model/ai_model.dart';

class ChatViewWidget extends StatelessWidget {
  const ChatViewWidget({super.key, required this.aiModel});

  final AIModel aiModel;

  @override
  Widget build(BuildContext context) {
    if (aiModel.isUser == true) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 8,
          ),
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/profile_img.png"),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .80,
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.purple.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: aiModel.images?.isNotEmpty ?? false,
                  child: SizedBox(
                    height: 120,
                    child: ListView.separated(
                      separatorBuilder: (context, i) => const SizedBox(width: 5),
                      itemCount: aiModel.images?.length ?? 0,
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
                                aiModel.images![index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  aiModel.text ?? "",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 8,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/ai_img.webp"),
              backgroundColor: Colors.transparent,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .80,
            child: Markdown(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              data: aiModel.text ?? "",
            ),
          ),
        ],
      );
    }
  }
}
