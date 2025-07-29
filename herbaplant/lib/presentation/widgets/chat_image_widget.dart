import 'dart:io';
import 'package:flutter/material.dart';

class ChatImageWidget extends StatelessWidget {
  final File imageFile;
  final bool isUser;
  final String timestamp;

  const ChatImageWidget({
    super.key,
    required this.imageFile,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isUser ? Colors.grey[200] : const Color(0xFFD0F0C0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(imageFile, width: 200, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 12),
            child: Text(
              timestamp,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
