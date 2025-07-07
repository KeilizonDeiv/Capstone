import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PlantInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Information"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset('assets/plants/rosemary.jpg'),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "🌿 Rosemary",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Botanical Name: Rosmarinus officinalis",
                style: TextStyle(fontSize: 14, color: AppColors.textLight),
              ),
            ),
            const Divider(height: 32),
            buildInfoSection("Uses", "Rosemary is used to treat muscle pain, improve memory, boost the immune and circulatory system, and promote hair growth."),
            buildInfoSection("Benefits", "Rich in antioxidants, improves digestion, enhances memory and concentration."),
            buildInfoSection("Where to Find", "Commonly found in gardens, pots, and local herbal farms."),
          ],
        ),
      ),
    );
  }

  Widget buildInfoSection(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(body, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 16),
      ],
    );
  }
}
