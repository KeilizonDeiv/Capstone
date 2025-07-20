import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:herbaplant/core/constants/app_colors.dart';
import 'package:herbaplant/presentation/widgets/custom_text_form_field.dart';
import 'package:herbaplant/presentation/widgets/success_dialog.dart';
import '../../widgets/confirmation_dialog.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
          onPressed: () => context.go('/profile'),
        ),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
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
                              backgroundColor: AppColors.maingreen,
                              child: const Icon(Icons.edit, color: Colors.white, size: 18),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      /// Email
                      CustomTextFormField(
                        controller: emailController,
                        label: 'Email Address',
                        prefixIcon: const Icon(Icons.email_outlined, color: AppColors.maingreen),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Email is required' : null,
                      ),
                      const SizedBox(height: 20),

                      /// Old Password
                      CustomTextFormField(
                        controller: oldPasswordController,
                        label: 'Old Password',
                        obscureText: obscureOldPassword,
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.maingreen),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureOldPassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() => obscureOldPassword = !obscureOldPassword);
                          },
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Old password is required' : null,
                      ),
                      const SizedBox(height: 20),

                      /// New Password
                      CustomTextFormField(
                        controller: newPasswordController,
                        label: 'New Password',
                        obscureText: obscureNewPassword,
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.maingreen),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() => obscureNewPassword = !obscureNewPassword);
                          },
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'New password is required' : null,
                      ),
                      const SizedBox(height: 20),

                      /// Confirm Password
                      CustomTextFormField(
                        controller: confirmPasswordController,
                        label: 'Confirm Password',
                        obscureText: obscureConfirmPassword,
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.maingreen),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() => obscureConfirmPassword = !obscureConfirmPassword);
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm password is required';
                          }
                          if (value != newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),

            /// Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.maingreen),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.maingreen)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (ctx) => ConfirmationDialog(
                              title: "Save Changes?",
                              message: "Are you sure you want to save your updated account info?",
                              onConfirm: () {
                                Navigator.of(ctx).pop(); // Close confirmation dialog
                                Future.delayed(const Duration(milliseconds: 200), () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => SuccessDialog(
                                      title: "Success",
                                      message: "Account successfully updated",
                                      onConfirm: () => Navigator.of(context).pop(),
                                    ),
                                  );
                                });
                              },
                              onCancel: () => Navigator.of(ctx).pop(),
                            ),
                          );
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
