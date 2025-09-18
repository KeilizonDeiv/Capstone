import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:herbaplant/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await AuthService.registerUser(
      _usernameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (response == null || response.containsKey("error")) {
      final errorMessage = response?["error"] ?? "Register Failed";
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
      return;
    }

    final msg = response["message"] ?? "Registration successful!";
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green),
    );

    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Gradient + background overlay
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0C553B), Color(0xFF2D5A3D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              image: DecorationImage(
                image: AssetImage('assets/image/bgplant.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.2),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                // Floating Create Account Text
                Positioned(
                  top: screenHeight * 0.15,
                  left: 24,
                  right: screenWidth * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Please sign up to continue',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form container
                Positioned(
                  top: screenHeight * 0.24,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: screenWidth,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D5A3D),
                              ),
                            ),
                            const SizedBox(height: 30),
                            _buildInputField(
                              controller: _emailController,
                              hintText: 'Email',
                              icon: Icons.email_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter an email";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _usernameController,
                              hintText: 'Username',
                              icon: Icons.person_4_outlined,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? "Please enter a username"
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _passwordController,
                              hintText: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              isPasswordVisible: _isPasswordVisible,
                              onToggleVisibility: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? "Please enter a password"
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _confirmPasswordController,
                              hintText: 'Confirm Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              isPasswordVisible: _isConfirmPasswordVisible,
                              onToggleVisibility: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please confirm your password";
                                }
                                if (value != _passwordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2D5A3D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Floating plant image
                Positioned(
                  right: 0,
                  top: screenHeight * 0.06,
                  child: IgnorePointer(
                    child: Image.asset(
                      'assets/image/plant.png',
                      width: screenWidth * 0.5,
                      height: screenWidth * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Back button
                Positioned(
                  top: 40,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Container(
          width: 60,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: const Color(0xFF2D5A3D),
          ),
        ),
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: onToggleVisibility,
                child: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF2D5A3D),
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0xFFB8B8B8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0xFFB8B8B8)),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }
}
