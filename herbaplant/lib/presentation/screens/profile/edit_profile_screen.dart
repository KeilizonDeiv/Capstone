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
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscureOldPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => context.go('/profile'),
        ),
        centerTitle: false,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF0C553B),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        titleSpacing: 0,
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

                      // Profile Image
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            const CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  AssetImage('assets/image/sample_profile.jpg'),
                            ),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Color(0xFF0C553B),
                              child: const Icon(Icons.edit, color: Colors.white, size: 18),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: 400,
                        height: 1,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 30),

                      // Email
                      CustomTextFormField(
                        controller: emailController,
                        label: 'Email Address',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF0C553B),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Email is required'
                            : null,
                      ),
                      const SizedBox(height: 10),

                      /// Old Password
                      CustomTextFormField(
                        controller: oldPasswordController,
                        label: 'Old Password',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        obscureText: obscureOldPassword,
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Color(0xFF0C553B)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureOldPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(
                                () => obscureOldPassword = !obscureOldPassword);
                          },
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Old password is required'
                            : null,
                      ),
                      const SizedBox(height: 10),

                      /// New Password
                      CustomTextFormField(
                        controller: newPasswordController,
                        label: 'New Password',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        obscureText: obscureNewPassword,
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Color(0xFF0C553B)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(
                                () => obscureNewPassword = !obscureNewPassword);
                          },
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'New password is required'
                            : null,
                      ),
                      const SizedBox(height: 10),

                      /// Confirm Password
                      CustomTextFormField(
                        controller: confirmPasswordController,
                        label: 'Confirm Password',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        obscureText: obscureConfirmPassword,
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Color(0xFF0C553B)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() => obscureConfirmPassword =
                                !obscureConfirmPassword);
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
                        side: const BorderSide(color: Color(0xFF0C553B)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(color: Color(0xFF0C553B))),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0C553B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (ctx) => ConfirmationDialog(
                              title: "Save Changes?",
                              message:
                                  "Are you sure you want to save your updated account info?",
                              onConfirm: () {
                                Navigator.of(ctx).pop();
                                Future.delayed(
                                    const Duration(milliseconds: 200), () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => SuccessDialog(
                                      title: "Success",
                                      message: "Account successfully updated",
                                      onConfirm: () =>
                                          Navigator.of(context).pop(),
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
