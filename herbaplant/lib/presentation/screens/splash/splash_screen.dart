import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();

    _lottieController = AnimationController(vsync: this);

    Future.delayed(const Duration(seconds: 2), _navigateToNextScreen);
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");
    final bool isFirstLogin = prefs.getBool("first_login") ?? true;

    if (token != null && isFirstLogin) {
      await prefs.setBool("first_login", false);
      if (mounted) context.go('/onboarding');
    } else if (token != null) {
      if (mounted) context.go('/home');
    } else {
      if (mounted) context.go('/login');
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Lottie animation background
          Positioned.fill(
            child: Lottie.asset(
              'assets/animations/splash.json',
              controller: _lottieController,
              fit: BoxFit.cover,
              onLoaded: (composition) {
                _lottieController
                  ..duration = composition.duration
                  ..forward();
              },
            ),
          ),

          // Logo centered
          Center(
            child: Image.asset(
              'assets/image/logonobg.png',
              width: 180,
            ),
          ),
        ],
      ),
    );
  }
}
