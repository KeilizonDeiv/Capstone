import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'plant_info.dart';

class PlantInfoScreen extends StatelessWidget {
  final PlantInfo plant;
  final String imageUrl;

  const PlantInfoScreen({
    super.key,
    required this.plant,
    required this.imageUrl,
  });

  Widget _buildSection(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...items.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text("• $e",
                  style: const TextStyle(fontSize: 14, height: 1.4)),
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C553B),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          plant.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image,
                    size: 120,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 16),

            Text(
              plant.scientificName,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              plant.description,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const Divider(height: 32),

            _buildSection("Uses", plant.uses),
            _buildSection("Health Benefits", plant.benefits),
            _buildSection("Fun Facts", plant.funFacts),

            if (plant.whereToFind.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Where to Find",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(plant.whereToFind,
                      style: const TextStyle(fontSize: 14, height: 1.4)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
