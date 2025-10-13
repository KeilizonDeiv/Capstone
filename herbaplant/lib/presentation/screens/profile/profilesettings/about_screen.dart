import 'package:flutter/material.dart';
import 'package:herbaplant/presentation/screens/profile/profilesettings/app_settings.dart';
import 'package:provider/provider.dart';
import 'package:herbaplant/providers/app_settings.dart';

class AboutHerbaPlantScreen extends StatelessWidget {
  const AboutHerbaPlantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final settings = Provider.of<AppSettings>(context);
    final t = settings.t;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: const Color(0xFF0C553B),
        title: Text(
          appSettings.t('aboutUs'),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Top banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF0C553B),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/image/logo-new.png'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HerbaPlant',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${appSettings.t('version')} 1.0.0',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoCard(
                    icon: Icons.spa,
                    title: t('ourMission'),
                    content: appSettings.t('aboutDescription'),
                  ),
                  const SizedBox(height: 16),
                  _InfoCard(
                    icon: Icons.groups,
                    title: appSettings.t('developedBy'),
                    content: 'HerbaTeam | 2025',
                  ),
                  const SizedBox(height: 32),

                  // Meet the Team
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0C553B).withOpacity(0.1),
                          const Color(0xFF0C553B).withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF0C553B).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.group, color: Color(0xFF0C553B)),
                            SizedBox(width: 12),
                            Text(
                              'Meet the Team',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        _TeamMember(
                          name: 'Katherine Guerrero',
                          position: 'Project Manager & Lead Developer',
                        ),
                        _TeamMember(
                          name: 'Keilizon-Deiv Leones & Jaspher Tania',
                          position: 'UI/UX Designer & Frontend Developer',
                        ),
                        _TeamMember(
                          name: 'Nervin Christopher Ferrer',
                          position: 'Backend Developer',
                        ),
                        _TeamMember(
                          name: 'John Mark Reyes',
                          position: 'System Analyst',
                        ),
                        _TeamMember(
                          name: 'Jerome Ibarra',
                          position: 'System Analyst',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable info card (like AboutPage)
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C553B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF0C553B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4A5568),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable team member card
class _TeamMember extends StatelessWidget {
  final String name;
  final String position;

  const _TeamMember({required this.name, required this.position});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0C553B), Color(0xFF08734A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  position,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
