import 'package:flutter/material.dart';
import 'package:herbaplant/services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _sendResetLink() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();

      final response = await AuthService.forgotPassword(email);

      if (response == null || response.containsKey("error")) {
        String msg = response?["error"] ?? "Something went wrong";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ $msg"), backgroundColor: Colors.red),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("📧 Password reset link sent to $email"),
            backgroundColor: Color(0xFF2D5A3D),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    OutlineInputBorder _border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: color, width: 1.5),
        );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        title: Text(
          "Forgot Password",
          style: TextStyle(
            fontSize: screenHeight * 0.028,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
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
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.71,
                  margin: EdgeInsets.only(top: screenHeight * 0.05),
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenHeight * 0.03),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: [
                            Icon(
                              Icons.lock_reset_rounded,
                              size: screenHeight * 0.06,
                              color: Color(0xFF2D5A3D),
                            ),
                            SizedBox(
                                width: screenWidth * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Reset Your Password",
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.025,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D5A3D),
                                    ),
                                  ),
                                  Text(
                                    "Enter your email to receive a reset link.",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: screenHeight * 0.018,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.025),
                        TextFormField(
                          controller: _emailController,
                          cursorColor: Color(0xFF2D5A3D),
                          keyboardType: TextInputType.emailAddress,
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
                            fillColor: isDark ? Colors.grey[900] : Colors.white,
                            enabledBorder:
                                _border(isDark ? Colors.white54 : Colors.grey),
                            focusedBorder: _border(const Color(0xFF2D5A3D)),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: screenHeight * 0.025),
                        ElevatedButton(
                          onPressed: _sendResetLink,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2D5A3D),
                            minimumSize:
                                Size(double.infinity, screenHeight * 0.065),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            "Send Reset Link",
                            style: TextStyle(
                              fontSize: screenHeight * 0.02,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
