import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/home'), // Use GoRouter's go method for navigation
 // Use go instead of push
        ),
      ),
      body: Column(
        children: [
          // Header with profile
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            width: double.infinity,
            color: Colors.green.shade800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/image/sample_profile.jpg'),
                ),
                const SizedBox(height: 10),
                const Text(
                  "User Name", // Replace with dynamic user name
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),

          // General Settings
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                sectionTitle("General Settings"),
                menuItem(
                  context,
                  icon: Icons.edit,
                  label: "Edit Profile",
                  onTap: () => context.push('/edit-profile'),
                ),
                menuItem(
                  context,
                  icon: Icons.history,
                  label: "Prompt History",
                  onTap: () => context.push('/prompt-history'),
                ),
                menuItem(
                  context,
                  icon: Icons.settings,
                  label: "Settings",
                  onTap: () => context.push('/settings'),
                ),
                const Divider(thickness: 1, height: 30),

                // Info
                sectionTitle("Info"),
                menuItem(
                  context,
                  icon: Icons.help_outline,
                  label: "Help",
                  onTap: () => context.push('/help'),
                ),
                menuItem(
                  context,
                  icon: Icons.info_outline,
                  label: "About Us",
                  onTap: () => context.push('/about'),
                ),
                const Divider(thickness: 1, height: 30),

                // Logout
                menuItem(
                  context,
                  icon: Icons.logout,
                  label: "Log out",
                  onTap: () {
                    context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Menu Section Title
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Clickable Menu Item
  Widget menuItem(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.green),
      ),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
