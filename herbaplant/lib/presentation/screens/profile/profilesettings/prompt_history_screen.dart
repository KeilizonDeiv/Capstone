import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PromptHistoryScreen extends StatelessWidget {
  const PromptHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true, // ✅ Center the title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/profile'); // ✅ Navigate back to the profile screen
          },
        ),
        title: const Text(
          "Prompt History",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              // Handle edit action
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 🔍 Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Scrollable list
            Expanded(
              child: ListView(
                children: const [
                  SectionHeader(title: "Today"),
                  PromptTile(
                    title: "Monstera Deliciosa",
                    subtitle: "A user's progressive inquiry into the care...",
                  ),
                  PromptTile(
                    title: "Snake Plant (Sansevieria)",
                    subtitle: "Exploring low-maintenance care routines...",
                  ),
                  PromptTile(
                    title: "Aloe Vera",
                    subtitle: "From basic plant care to harvesting aloe gel...",
                  ),
                  SectionHeader(title: "Previous 7 Days"),
                  PromptTile(
                    title: "Peace Lily (Spathiphyllum)",
                    subtitle: "Understanding watering habits, bloom cycles...",
                  ),
                  PromptTile(
                    title: "Basil Plant",
                    subtitle: "A journey from kitchen garden setup to pruning...",
                  ),
                  PromptTile(
                    title: "Succulents",
                    subtitle: "User questions about sunlight, watering...",
                  ),
                  SectionHeader(title: "Previous Months"),
                  PromptTile(
                    title: "Orchid (Phalaenopsis)",
                    subtitle: "Delving into bloom care, humidity control...",
                  ),
                  PromptTile(
                    title: "Tomato Plant",
                    subtitle: "From seeding to harvest—questions about sunlight...",
                  ),
                  PromptTile(
                    title: "ZZ Plant (Zamioculcas zamiifolia)",
                    subtitle: "A look into low-light resilience and watering...",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }
}

class PromptTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const PromptTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.chat_bubble_outline, color: Colors.green),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigate to detail screen
      },
    );
  }
}
