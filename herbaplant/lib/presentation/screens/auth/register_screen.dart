import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _acceptTerms = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  void _togglePassword() {
    setState(() => _hidePassword = !_hidePassword);
  }

  void _toggleConfirmPassword() {
    setState(() => _hideConfirmPassword = !_hideConfirmPassword);
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate() || !_acceptTerms) {
      _showSnackbar("Please fill all fields and accept terms", Colors.red, Icons.warning);
      return;
    }

    _showSnackbar("✅ Form looks good! Ready for backend", Colors.green, Icons.check_circle);
  }

  void _showSnackbar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset("assets/logo.png", height: 90),
                const SizedBox(height: 20),
                Text("Create Account", style: AppTextStyles.title),
                const SizedBox(height: 24),

                // Username
                TextFormField(
                  controller: _username,
                  maxLength: 20,
                  decoration: _input("Username", Icons.person),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),

                const SizedBox(height: 12),

                // Email
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  decoration: _input("Email", Icons.email),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    return emailRegex.hasMatch(val) ? null : 'Invalid email';
                  },
                ),

                const SizedBox(height: 12),

                // Password
                TextFormField(
                  controller: _password,
                  obscureText: _hidePassword,
                  maxLength: 30,
                  decoration: _input(
                    "Password",
                    Icons.lock,
                    suffix: IconButton(
                      icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: _togglePassword,
                    ),
                  ),
                  validator: (val) => val != null && val.length >= 6 ? null : 'Min 6 characters',
                ),

                const SizedBox(height: 12),

                // Confirm Password
                TextFormField(
                  controller: _confirmPassword,
                  obscureText: _hideConfirmPassword,
                  maxLength: 30,
                  decoration: _input(
                    "Confirm Password",
                    Icons.lock,
                    suffix: IconButton(
                      icon: Icon(_hideConfirmPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: _toggleConfirmPassword,
                    ),
                  ),
                  validator: (val) => val == _password.text ? null : 'Passwords do not match',
                ),

                const SizedBox(height: 16),

                // Terms and Conditions
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: _showTerms,
                        child: const Text(
                          "I agree to the Terms and Conditions",
                          style: TextStyle(color: AppColors.primary, decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Create Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Create Account", style: TextStyle(fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      counterText: '',
      prefixIcon: Icon(icon, color: AppColors.primary),
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Terms and Conditions"),
        content: const SingleChildScrollView(
          child: Text(
            "This is a dummy terms and conditions text. Replace this with your real content before deploying.",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _acceptTerms = true);
              Navigator.pop(context);
            },
            child: const Text("Agree"),
          ),
        ],
      ),
    );
  }
}
