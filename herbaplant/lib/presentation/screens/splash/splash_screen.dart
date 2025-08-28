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

    Future.delayed(const Duration(seconds: 2), () {
      final location =
          GoRouter.of(context).routeInformationProvider.value.uri.path;

      debugPrint("⏳ Splash redirect check, location=$location");

      if (mounted && (location == "/" || location.isEmpty)) {
        context.go('/login');
      }
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
