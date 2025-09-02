import 'package:flutter/material.dart';
import 'package:herbaplant/presentation/screens/profile/profilesettings/app_settings.dart';
import 'package:provider/provider.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

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
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSwitchTile(
            title: 'Dark Mode',
            subtitle: appSettings.isDarkMode ? 'Currently: Dark' : 'Currently: Light',
            value: appSettings.isDarkMode,
            onChanged: (_) => appSettings.toggleDarkMode(),
            icon: Icons.dark_mode_outlined,
          ),
          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: "Current: ${appSettings.language}",
            onTap: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: const Text("Choose Language"),
                  children: [
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(ctx, 'English'),
                      child: const Text("English"),
                    ),
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(ctx, 'Filipino'),
                      child: const Text("Filipino"),
                    ),
                  ],
                ),
              );
              if (result != null) appSettings.changeLanguage(result);
            },
          ),
          _buildSettingsTile( icon: Icons.privacy_tip_outlined, title: 'Privacy Policy', subtitle: 'View our privacy policy', onTap: () {}, ),
        ],
      ),
    );
  }

  Future<void> _changeLanguage(
      BuildContext context, AppSettings appSettings) async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text("Choose Language"),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'English'),
            child: const Text("English"),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'Filipino'),
            child: const Text("Filipino"),
          ),
        ],
      ),
    );

    if (result != null) {
      appSettings.changeLanguage(result);
    }
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          leading: Icon(icon, color: const Color(0xFF0C553B)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Column(
      children: [
        SwitchListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          activeColor: const Color(0xFF0C553B),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          value: value,
          onChanged: onChanged,
          secondary: Icon(icon, color: const Color(0xFF0C553B)),
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}
