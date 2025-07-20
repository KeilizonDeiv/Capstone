import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:herbaplant/core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Log out?"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close dialog
              context.go('/login'); // Go to login screen
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.maingreen),
            child: const Text("Log out"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.maingreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.push('/home'),
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            width: double.infinity,
            color: AppColors.maingreen,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/image/sample_profile.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  "User Name",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),

          // Content + Logout Button at Bottom
          Expanded(
            child: Column(
              children: [
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
                    ],
                  ),
                ),

                // Sticky Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text("Log out", style: TextStyle(color: Colors.white)),
                    onPressed: () => _showLogoutConfirmation(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section Title
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Menu Item
  Widget menuItem(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.maingreen),
      ),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
