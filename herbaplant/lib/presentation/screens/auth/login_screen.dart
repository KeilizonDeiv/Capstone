import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:herbaplant/presentation/screens/auth/forgot_password_screen.dart';
import 'package:herbaplant/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final response = await AuthService.loginUser(
          _emailController.text.trim(), _passwordController.text.trim());

      if (response == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Login Failed.")));
      }

      if (response!.containsKey("error")) {
        String errorMessage = response["error"];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", response["token"]);

      GoRouter.of(context).go('/home');
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<void> _handleGoogleLogin() async {
    try {
      final response = await AuthService.signInWithGoogle();

      if (response == null || !response.containsKey("token")) {
        String msg = response?["error"] ?? "Google login failed";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", response['token']);

      GoRouter.of(context).go('/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Google login failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    OutlineInputBorder _border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: color, width: 1.5),
        );

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background overlay
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
                // "Hello.." Text floating
                Positioned(
                  top: screenHeight * 0.15,
                  left: 24,
                  right: screenWidth * 0.3, // leave space for plant image
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hello..',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Please login to continue',
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
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(22),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Login',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D5A3D),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Email
                            TextFormField(
                              controller: _emailController,
                              cursorColor: const Color(0xFF2D5A3D),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.grey,
                                ),
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: Color(0xFF2D5A3D),
                                ),
                                filled: true,
                                fillColor:
                                    isDark ? Colors.grey[900] : Colors.white,
                                enabledBorder: _border(
                                    isDark ? Colors.white54 : Colors.grey),
                                focusedBorder: _border(const Color(0xFF2D5A3D)),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              cursorColor: const Color(0xFF2D5A3D),
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.grey,
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Color(0xFF2D5A3D),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color:
                                        isDark ? Colors.white70 : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor:
                                    isDark ? Colors.grey[900] : Colors.white,
                                enabledBorder: _border(
                                    isDark ? Colors.white54 : Colors.grey),
                                focusedBorder: _border(const Color(0xFF2D5A3D)),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const ForgotPasswordScreen()),
                                  );
                                },
                                child: Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Color(0xFF2D5A3D),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2D5A3D),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                'or login with',
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: _handleGoogleLogin,
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  side: BorderSide(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.grey[300]!),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/image/g.png',
                                      height: 24,
                                      width: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Divider(endIndent: 130, indent: 130),
                            const SizedBox(height: 20),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      color:
                                          isDark ? Colors.white70 : Colors.grey,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const RegisterScreen()),
                                      );
                                    },
                                    child: const Text(
                                      'Sign up',
                                      style: TextStyle(
                                        color: Color(0xFF2D5A3D),
                                        fontWeight: FontWeight.w600,
                                      ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
