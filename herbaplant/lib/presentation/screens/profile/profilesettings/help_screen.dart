import 'package:flutter/material.dart';
import 'package:herbaplant/presentation/screens/profile/profilesettings/app_settings.dart';
import 'package:provider/provider.dart';
import 'package:herbaplant/providers/app_settings.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C553B),
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          appSettings.t('helpSupport'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            appSettings.t('frequentlyAskedQuestions'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildFaqTile(
            question: appSettings.t('faqQuestion1'),
            answer: appSettings.t('faqAnswer1'),
          ),
          _buildFaqTile(
            question: appSettings.t('faqQuestion2'),
            answer: appSettings.t('faqAnswer2'),
          ),
          _buildFaqTile(
            question: appSettings.t('faqQuestion3'),
            answer: appSettings.t('faqAnswer3'),
          ),
          const Divider(height: 40),
          Text(
            appSettings.t('contactUs'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.email,
                color: Colors.green,
              ),
            ),
            title: const Text('herbaplant00@gmail.com'),
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
