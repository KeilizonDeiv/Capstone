// lib/data/history_prompt.dart

class PromptEntry {
  final String question;
  final String answer;

  PromptEntry({required this.question, required this.answer});
}

class PromptHistoryService {
  static Future<List<Map<String, String>>> fetchPromptHistory() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
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
  }
}
