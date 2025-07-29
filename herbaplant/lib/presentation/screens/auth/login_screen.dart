import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:herbaplant/presentation/screens/auth/forgot_password_screen.dart';
import 'package:herbaplant/presentation/screens/auth/register_screen.dart';
import '../../widgets/custom_text_form_field.dart';
import 'package:herbaplant/core/constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      GoRouter.of(context).go('/home');
    }
  }

  InputDecoration _inputDecoration(String label, Icon prefixIcon, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.maingreen),
      ),
      counterText: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
        child: Column(
          children: [
            // Logo
            Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/image/logo-new.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 40),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.maingreen,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Log in to your account.',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Email
                  CustomTextFormField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.person, color: AppColors.maingreen),
                      maxLength: 50,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),

                  const SizedBox(height: 12),

                  // Password
                  CustomTextFormField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: _obscurePassword,
                    maxLength: 20,
                    prefixIcon: const Icon(Icons.lock, color: AppColors.maingreen),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: AppColors.maingreen),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  // Login Button
                  ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 16, 114, 19),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Divider
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Colors.black26)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Or'),
                      ),
                      Expanded(child: Divider(color: Colors.black26)),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Register Button
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color.fromARGB(255, 16, 114, 19)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 16, 114, 19)),
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
