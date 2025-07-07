import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class PromptHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> history = [
    {
      "question": "What are the benefits of oregano?",
      "answer": "Oregano helps with inflammation, cough, and digestion.",
    },
    {
      "question": "Where can I find lagundi?",
      "answer": "Lagundi is commonly found in tropical areas and local gardens.",
    },
    {
      "question": "How do I use ginger for colds?",
      "answer": "Boil slices of ginger in water and drink as tea 2-3 times a day.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prompt History")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = history[index];
          return ListTile(
            title: Text(item["question"]!, style: AppTextStyles.subtitle),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(item["answer"]!, style: AppTextStyles.body),
            ),
            leading: const Icon(Icons.history, color: AppColors.primary),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                // Optional: delete function (future implementation)
              },
            ),
          );
        },
      ),
    );
  }
}
