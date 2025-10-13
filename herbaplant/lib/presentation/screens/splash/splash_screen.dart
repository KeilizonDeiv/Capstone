import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _decideNavigation();
  }

  Future<void> _decideNavigation() async {
    // Let the splash animation play at least 2s
    await Future.delayed(const Duration(seconds: 2));

    final appLinks = AppLinks();
    Uri? initialUri;

    try {
      // Try normal deep link
      initialUri = await appLinks.getInitialAppLink();

      // Fallback: wait up to 5s for stream on cold start
      if (initialUri == null) {
        initialUri = await appLinks.uriLinkStream
            .first
            .timeout(const Duration(seconds: 5));
      }
    } on TimeoutException {
      initialUri = null;
    }

    if (!mounted) return;

    if (initialUri != null) {
      final query = initialUri.hasQuery ? '?${initialUri.query}' : '';
      var path = initialUri.path.isNotEmpty ? initialUri.path : '/reset-password';
      if (path.endsWith('/')) path = path.substring(0, path.length - 1);

      final location = '$path$query';
      debugPrint("🚀 Splash deep link → $location");
      context.go(location);
      return;
    }

    // TODO: auth check here if needed
    context.go('/login');
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
