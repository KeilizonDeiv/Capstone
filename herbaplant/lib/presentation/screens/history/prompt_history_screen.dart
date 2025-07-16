import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'history_prompt.dart';

class PromptHistoryScreen extends StatefulWidget {
  const PromptHistoryScreen({super.key});

  @override
  State<PromptHistoryScreen> createState() => _PromptHistoryScreenState();
}

class _PromptHistoryScreenState extends State<PromptHistoryScreen> {
  late Future<List<Map<String, String>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = PromptHistoryService.fetchPromptHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prompt History")),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading history."));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No prompt history found."));
          }

          final history = snapshot.data!;

          return ListView.separated(
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
                    // TODO: handle delete
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
