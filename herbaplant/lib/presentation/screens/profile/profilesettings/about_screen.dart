import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Only needed if you're using GoRouter

class AboutHerbaPlantScreen extends StatelessWidget {
  const AboutHerbaPlantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C553B),
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "About us",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/image/logo-new.png'),
            ),
            const SizedBox(height: 16),
            const Text(
              'HerbaPlant',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              'HerbaPlant is a plant identification and educational app dedicated to Philippine herbal plants. We aim to empower users with knowledge about the medicinal use, growth, and care of these plants.',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            const Text(
              'Developed by HerbaTeam | 2025',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
