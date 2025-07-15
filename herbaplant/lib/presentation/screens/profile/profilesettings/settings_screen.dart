import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/profile'), // ✅ Use context.push to navigate back
 // Use go_router's pop
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: true,
            onChanged: (value) {},
            secondary: const Icon(Icons.notifications_active),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // Add dark mode logic
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // Add language selection
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {}, // Add privacy navigation
          ),
        ],
      ),
    );
  }
}
