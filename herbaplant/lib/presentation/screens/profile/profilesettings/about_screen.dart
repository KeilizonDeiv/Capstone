import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Only needed if you're using GoRouter

class AboutHerbaPlantScreen extends StatelessWidget {
  const AboutHerbaPlantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/profile'),// use Navigator.pop(context) if you're not using GoRouter
        ),
        title: const Text('About HerbaPlant'),
        backgroundColor: Colors.green.shade700,
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
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const Text(
              'Developed by Team HerbaTech | 2025',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
