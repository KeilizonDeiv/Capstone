import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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

    // Navigate to LoginScreen after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/login'); // ⬅️ Navigate to login screen only
    });
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

          // Centered logo
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
