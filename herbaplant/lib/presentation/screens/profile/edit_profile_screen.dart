import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:herbaplant/core/constants/app_colors.dart';
import 'package:herbaplant/presentation/screens/profile/profilesettings/app_settings.dart';
import 'package:herbaplant/presentation/widgets/custom_text_form_field.dart';
import 'package:herbaplant/presentation/widgets/success_dialog.dart';
import 'package:herbaplant/services/auth_service.dart';
import 'package:herbaplant/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/confirmation_dialog.dart';
import 'package:image_picker/image_picker.dart';

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

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions() {
    final t = Provider.of<AppSettings>(context, listen: false).t;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(t('takePhoto') ?? 'Take a Photo'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: Text(t('chooseFromGallery') ?? 'Choose from Gallery'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: 1.3),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final settings = Provider.of<AppSettings>(context);
    final t = settings.t;

    OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 1.2),
        );

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C553B),
        elevation: 1,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.go('/profile'),
        ),
        centerTitle: false,
        title: Text(
          t("editProfileTitle"),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
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
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : const AssetImage(
                                          'assets/image/sample_profile.jpg')
                                      as ImageProvider,
                            ),
                            GestureDetector(
                              onTap: _showImagePickerOptions,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xFF0C553B),
                                child: const Icon(Icons.edit,
                                    color: Colors.white, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Divider
                      Container(
                        width: 400,
                        height: 1,
                        color: isDark ? Colors.grey[800] : Colors.grey,
                      ),
                      const SizedBox(height: 30),

                      /// Old Password
                      CustomTextFormField(
                        controller: oldPasswordController,
                        label: t("oldPassword"),
                        labelStyle: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey,
                        ),
                        obscureText: obscureOldPassword,
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Color(0xFF0C553B)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureOldPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: isDark ? Colors.white70 : Colors.grey,
                          ),
                          onPressed: () => setState(
                              () => obscureOldPassword = !obscureOldPassword),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? t('oldPasswordRequired')
                            : null,
                        decoration: InputDecoration(
                          enabledBorder:
                              _border(isDark ? Colors.white54 : Colors.grey),
                          focusedBorder: _border(
                              isDark ? Colors.white : const Color(0xFF0C553B)),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// New Password
                      CustomTextFormField(
                        controller: newPasswordController,
                        label: t("newPassword"),
                        labelStyle: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey,
                        ),
                        obscureText: obscureNewPassword,
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Color(0xFF0C553B)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: isDark ? Colors.white70 : Colors.grey,
                          ),
                          onPressed: () {
                            setState(
                                () => obscureNewPassword = !obscureNewPassword);
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t('newPasswordRequired');
                          }
                          if (value.length < 6) {
                            return t('passwordTooShort');
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: _inputBorder(
                              isDark ? Colors.white54 : Colors.grey),
                          focusedBorder: _inputBorder(
                              isDark ? Colors.white : const Color(0xFF0C553B)),
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// Confirm Password
                      CustomTextFormField(
                        controller: confirmPasswordController,
                        label: t("confirmPassword"),
                        labelStyle: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey,
                        ),
                        obscureText: obscureConfirmPassword,
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Color(0xFF0C553B)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: isDark ? Colors.white70 : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() => obscureConfirmPassword =
                                !obscureConfirmPassword);
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t('confirmPasswordRequired');
                          }
                          if (value != newPasswordController.text) {
                            return t('passwordsDoNotMatch');
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: _inputBorder(
                              isDark ? Colors.white54 : Colors.grey),
                          focusedBorder: _inputBorder(
                              isDark ? Colors.white : const Color(0xFF0C553B)),
                        ),
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
                      child: Text(
                        t("cancel"),
                        style: const TextStyle(color: Color(0xFF0C553B)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C553B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        final isChangingPassword =
                            oldPasswordController.text.isNotEmpty ||
                                newPasswordController.text.isNotEmpty ||
                                confirmPasswordController.text.isNotEmpty;

                        if (isChangingPassword) {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              builder: (ctx) => ConfirmationDialog(
                                title: t("saveChangesQuestion"),
                                message: t("updatePasswordConfirm"),
                                onConfirm: () async {
                                  Navigator.of(ctx).pop();
                                  final result =
                                      await AuthService.changePassword(
                                    oldPasswordController.text.trim(),
                                    newPasswordController.text.trim(),
                                  );

                                  if (result["error"] != null) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => SuccessDialog(
                                        title: t("errorTitle") ?? "Error",
                                        message: result["error"],
                                        onConfirm: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (_) => SuccessDialog(
                                        title: t("successTitle") ?? "Success",
                                        message: result["message"] ??
                                            t("passwordUpdated"),
                                        onConfirm: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    );
                                  }
                                },
                                onCancel: () => Navigator.of(ctx).pop(),
                              ),
                            );
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => SuccessDialog(
                              title: t("successTitle") ?? "Success",
                              message: t("profilePicUpdated"),
                              onConfirm: () => Navigator.of(context).pop(),
                            ),
                          );
                          if (_imageFile != null) {
                            final result =
                                await UserService.updateProfilePicture(
                                    _imageFile!);

                            if (result["error"] != null) {
                              showDialog(
                                context: context,
                                builder: (_) => SuccessDialog(
                                  title: t("errorTitle") ?? "Error",
                                  message: result["error"],
                                  onConfirm: () =>
                                      Navigator.of(context).pop(),
                                ),
                              );
                            } else {
                              if (result["profile_image"] != null) {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                    "profile_image", result["profile_image"]);
                              }

                              showDialog(
                                context: context,
                                builder: (_) => SuccessDialog(
                                  title: t("successTitle") ?? "Success",
                                  message: result["message"] ??
                                      t("profilePicUpdated"),
                                  onConfirm: () {
                                    Navigator.of(context).pop();
                                    context.go('/profile');
                                  },
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: Text(t("save")),
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