import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:herbaplant/presentation/screens/auth/forgot_password_screen.dart';
import 'package:herbaplant/presentation/screens/auth/register_screen.dart';
import 'package:herbaplant/presentation/screens/main/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // ⏩ Go to home screen for now
      GoRouter.of(context).go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  resizeToAvoidBottomInset: false,
  backgroundColor: Colors.white, // Set Scaffold background to white
  body: Stack(
    children: [
      // Background
      Container(
        color: Colors.white, // Pure white background
      ),

          // Form Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 80),
                      // Logo
                      Container(
                          width: 125,
                          height: 125,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color.fromARGB(255, 0, 0, 0), // Border color
                              width: 2.0,          // Border width
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/image/logo-new.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover, // Use cover for better cropping
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                      // Form Box
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left
                            children: [
                              const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 16, 114, 19),
                                ),
                              ),
                            const SizedBox(height: 8),
                              const Text(
                                'Log in to your account.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            const SizedBox(height: 12),

                            // Email
                            TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                maxLength: 50,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person, color: Colors.green),
                                  labelText: 'Email',
                                  counterText: "",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(color: Colors.black), // Default border
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(color: Colors.black), // Black when not focused
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(color: Colors.black, width: 2), // Black when focused
                                  ),
                                ),
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
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              maxLength: 20,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock, color: Colors.green),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                labelText: 'Password',
                                counterText: "",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.black), // Black border when not focused
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.black, width: 2), // Black border when focused
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 12),

                            // Forgot password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style:
                                      TextStyle(color: Colors.green.shade700),
                                ),
                              ),
                            ),

                            // Login Button
                            SizedBox(
                              width: double.infinity, // Makes it expand full width
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 16, 114, 19),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Divider
                            Row(
                              children: const [
                                Expanded(
                                    child: Divider(color: Colors.black26)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('Or'),
                                ),
                                Expanded(
                                    child: Divider(color: Colors.black26)),
                              ],
                            ),
                            const SizedBox(height: 15),

                            // Register Button
                            SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color.fromARGB(255, 16, 114, 19)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 16, 114, 19)),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
