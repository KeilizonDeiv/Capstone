import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'widgets/plant_preview_card.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> featuredPlants = [
    {
      "name": "Rosemary",
      "image": "assets/plants/rosemary.jpg",
      "tagline": "Aromatic herb used for healing.",
    },
    {
      "name": "Lagundi",
      "image": "assets/plants/lagundi.jpg",
      "tagline": "Traditional cure for cough and asthma.",
    },
    // Add more as needed
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HerbaPlant"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {}, // Later for notifications
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Featured Plants", style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featuredPlants.length,
                itemBuilder: (context, index) {
                  final plant = featuredPlants[index];
                  return PlantPreviewCard(
                    name: plant["name"]!,
                    imagePath: plant["image"]!,
                    tagline: plant["tagline"]!,
                    onTap: () {
                      Navigator.pushNamed(context, '/plant_info');
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text("Recently Scanned", style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Image.asset('assets/plants/rosemary.jpg', width: 50),
                    title: const Text("Rosemary"),
                    subtitle: const Text("Scanned on July 7"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.pushNamed(context, '/plant_info'),
                  ),
                  // Add more scanned items here
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
