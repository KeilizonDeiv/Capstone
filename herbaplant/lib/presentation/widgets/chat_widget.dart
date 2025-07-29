import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class UserMessageBubble extends StatelessWidget {
  final String text;
  final String? time;

  const UserMessageBubble({super.key, required this.text, this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
            if (time != null)
              Text(
                time!,
                style: const TextStyle(fontSize: 10, color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }
}

class BotMessageBubble extends StatelessWidget {
  final String text;
  final String? time;

  const BotMessageBubble({super.key, required this.text, this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.black87),
            ),
            if (time != null)
              Text(
                time!,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
          ],
        ),
      ),
    );
  }
}

class ImageMessageBubble extends StatelessWidget {
  final String imagePath;
  final bool isUser;

  const ImageMessageBubble({
    super.key,
    required this.imagePath,
    this.isUser = true,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final borderColor = isUser ? AppColors.primary : Colors.green;

    final file = File(imagePath);

    return FutureBuilder<bool>(
      future: file.exists().then((exists) async {
        if (!exists) return false;
        return (await file.length()) > 0;
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == false) {
          return const Text(
            "[Image could not be loaded]",
            style: TextStyle(color: Colors.red),
          );
        }

        return Align(
          alignment: alignment,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                file,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}


// Optional placeholder for future speech bubble
class VoiceMessageBubble extends StatelessWidget {
  final bool isUser;
  final Duration duration;

  const VoiceMessageBubble({
    super.key,
    required this.isUser,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final alignment =
        isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bgColor = isUser ? AppColors.primary : Colors.green.shade100;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mic, size: 20),
            const SizedBox(width: 8),
            Text("${duration.inSeconds}s"),
          ],
        ),
      ),
    );
  }
}
