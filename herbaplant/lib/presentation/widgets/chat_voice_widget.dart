import 'package:flutter/material.dart';

class ChatVoiceWidget extends StatelessWidget {
  final bool isUser;
  final String timestamp;

  const ChatVoiceWidget({
    super.key,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isUser ? Colors.grey[300] : const Color(0xFFD0F0C0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_arrow, color: isUser ? Colors.black : Colors.green[900]),
                const SizedBox(width: 8),
                const Text("Voice message", style: TextStyle(fontSize: 14)),
              ],
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
