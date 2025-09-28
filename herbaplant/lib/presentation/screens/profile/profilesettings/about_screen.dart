import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:herbaplant/presentation/screens/profile/profilesettings/app_settings.dart';
import 'package:provider/provider.dart';
import 'package:herbaplant/providers/app_settings.dart';

class AboutHerbaPlantScreen extends StatelessWidget {
  const AboutHerbaPlantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appSettings = Provider.of<AppSettings>(context);

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
          appSettings.t('aboutUs'),
          style: const TextStyle(
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
            Text(
              'HerbaPlant',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${appSettings.t('version')} 1.0.0',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              appSettings.t('aboutDescription'),
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              '${appSettings.t('developedBy')} HerbaTeam | 2025',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}