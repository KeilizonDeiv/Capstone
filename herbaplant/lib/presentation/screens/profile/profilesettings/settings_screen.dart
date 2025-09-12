import 'package:flutter/material.dart';
import 'package:herbaplant/presentation/screens/profile/profilesettings/app_settings.dart';
import 'package:herbaplant/presentation/screens/profile/profilesettings/privacy_policy_screen.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C553B), // ✅ brand color
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
          // ✅ Dark Mode toggle
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            activeColor: const Color(0xFF0C553B),
            title: Text(
              "Dark Mode",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              appSettings.isDarkMode ? "Currently: Dark" : "Currently: Light",
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.grey,
              ),
            ),
            value: appSettings.isDarkMode,
            onChanged: (value) => appSettings.toggleDarkMode(value),
            secondary: const Icon(Icons.dark_mode_outlined, color: Color(0xFF0C553B)),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? Colors.grey[800] : Colors.grey[300],
          ),

          // ✅ Language
          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: "Current: ${appSettings.language}",
            onTap: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: const Text("Choose Language"),
                  backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                  titleTextStyle: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(ctx, 'English'),
                      child: Text(
                        "English",
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      ),
                    ),
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(ctx, 'Filipino'),
                      child: Text(
                        "Filipino",
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              );
              if (result != null) appSettings.changeLanguage(result);
            },
            isDark: isDark,
          ),

          // ✅ Privacy Policy
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'View our privacy policy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              );
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDark = false,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          leading: Icon(icon, color: const Color(0xFF0C553B)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.grey,
                ),
              ),
            ],
          ),
          trailing: Icon(Icons.chevron_right,
              color: isDark ? Colors.white70 : Colors.grey),
          onTap: onTap,
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: isDark ? Colors.grey[800] : Colors.grey[300],
        ),
      ],
    );
  }
}
