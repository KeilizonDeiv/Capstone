import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C553B),
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Help & Support",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildFaqTile(
            question: 'How do I identify a plant?',
            answer: "Tap the 'Identify' button and take a clear photo.",
          ),
          _buildFaqTile(
            question: 'How do I save my plant history?',
            answer: "Your history is saved automatically after identification.",
          ),
          _buildFaqTile(
            question: 'Can I get info about non-herbal plants?',
            answer: "This app focuses on herbal plants only.",
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

  Widget _buildFaqTile({required String question, required String answer}) {
    return Card(
      color: Colors.transparent, // No background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.grey), // Grey border
      ),
      elevation: 0, // Remove shadow
      child: ExpansionTile(
        title: Text(question),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}
