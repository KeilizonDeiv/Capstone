import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/profile'), // GoRouter-compatible back button
        ),
        title: const Text('Help & Support'),
        backgroundColor: Colors.green.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ExpansionTile(
            title: const Text('How do I identify a plant?'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Tap the 'Identify' button and take a clear photo."),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('How do I save my plant history?'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Your history is saved automatically after identification."),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Can I get info about non-herbal plants?'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("This app focuses on herbal plants only."),
              ),
            ],
          ),
          const Divider(height: 40),
          const Text(
            'Contact Us',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('support@herbaplant.app'),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('+63 912 345 6789'),
          ),
        ],
      ),
    );
  }
}
