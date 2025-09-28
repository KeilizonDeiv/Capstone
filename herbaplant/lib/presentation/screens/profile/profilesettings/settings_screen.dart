import 'package:flutter/material.dart';
import 'package:herbaplant/presentation/screens/profile/profilesettings/app_settings.dart';
import 'package:herbaplant/presentation/screens/profile/profilesettings/privacy_policy_screen.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _buildLanguageTile(String language, bool isSelected, bool isDark, VoidCallback onTap) {
    return ListTile(
      leading: const Icon(Icons.language, color: Color(0xFF2D5A3D), size: 20),
      title: Text(
        language,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Color(0xFF2D5A3D), size: 20)
          : null,
      onTap: onTap,
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
          trailing: Icon(Icons.chevron_right, color: isDark ? Colors.white70 : Colors.grey),
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

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = settings.t;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C553B),
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          t('settings'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            activeColor: const Color(0xFF0C553B),
            title: Text(
              t('darkMode'),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              settings.isDarkMode ? t('currentlyDark') : t('currentlyLight'),
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.grey,
              ),
            ),
            value: settings.isDarkMode,
            onChanged: (value) => settings.toggleDarkMode(value),
            secondary: const Icon(Icons.dark_mode_outlined, color: Color(0xFF0C553B)),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? Colors.grey[800] : Colors.grey[300],
          ),

          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: t('language'),
            subtitle: "${t('current')}: ${settings.language}",
            isDark: isDark,
            onTap: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                  title: Text(
                    t('chooseLanguage'),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLanguageTile(
                        'English',
                        settings.language == 'English',
                        isDark,
                        () => Navigator.of(ctx).pop('English'),
                      ),
                      Divider(color: isDark ? Colors.white24 : Colors.grey[300]),
                      _buildLanguageTile(
                        'Filipino',
                        settings.language == 'Filipino',
                        isDark,
                        () => Navigator.of(ctx).pop('Filipino'),
                      ),
                    ],
                  ),
                ),
              );
              
              if (result != null) {
                settings.changeLanguage(result);
              }
            },
          ),

          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: t('privacyPolicy'),
            subtitle: t('viewPrivacyPolicy'),
            isDark: isDark,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}