import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // IMPORTANT: make sure this is imported

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool obscureOldPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () =>  context.go('/profile'),// <-- GoRouter-compatible back
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            /// Profile Image
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/image/sample_profile.jpg'),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            /// Email Field
            _buildLabel('Email'),
            _buildTextField(
              controller: emailController,
              icon: Icons.email_outlined,
              hintText: 'Email address',
            ),

            const SizedBox(height: 20),

            /// Old Password Field
            _buildLabel('Old Password'),
            _buildPasswordField(
              controller: oldPasswordController,
              obscureText: obscureOldPassword,
              toggleVisibility: () => setState(() => obscureOldPassword = !obscureOldPassword),
            ),

            const SizedBox(height: 20),

            /// New Password Field
            _buildLabel('New Password'),
            _buildPasswordField(
              controller: newPasswordController,
              obscureText: obscureNewPassword,
              toggleVisibility: () => setState(() => obscureNewPassword = !obscureNewPassword),
            ),

            const SizedBox(height: 20),

            /// Confirm Password Field
            _buildLabel('Confirm Password'),
            _buildPasswordField(
              controller: confirmPasswordController,
              obscureText: obscureConfirmPassword,
              toggleVisibility: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
            ),

            const SizedBox(height: 30),

            /// Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(), // <-- Cancel goes back
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.green)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add save logic here
                      // For example: show success and go back
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Changes saved')),
                      );
                      context.pop(); // or navigate somewhere else
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Label Text Widget
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Reusable TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Reusable Password Field
  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: toggleVisibility,
        ),
        hintText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
