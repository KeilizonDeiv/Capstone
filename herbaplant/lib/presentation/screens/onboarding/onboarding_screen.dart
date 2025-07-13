import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _onIntroEnd(BuildContext context) async {
    // 🔧 UI-Only: Simulate first-time login logic
    // Later replace this with API or SharedPreferences
    await Future.delayed(const Duration(milliseconds: 500));

    if (context.mounted) {
      GoRouter.of(context).go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/image/bgplant.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "Welcome to HerbaPlant!",
              body: "Discover and identify herbal plants around you.",
              image: Center(
                child: Image.asset("assets/image/logo-new.png", width: 250),
              ),
              decoration: _pageDecoration(),
            ),
            PageViewModel(
              title: "Scan and Diagnose",
              body: "Take a picture to get herbal plant details instantly!",
              image: Center(
                child: Lottie.asset("assets/animations/scanplanta.json", width: 250, height: 250),
              ),
              decoration: _pageDecoration(),
            ),
            PageViewModel(
              title: "Ask About Herbal Plants",
              body: "Have questions about a herb? Chat and get instant details on herbal plants!",
              image: Center(
                child: Image.asset("assets/animations/typing.gif", width: 200, height: 200),
              ),
              decoration: _pageDecoration(),
            ),
          ],
          onDone: () => _onIntroEnd(context),
          onSkip: () => _onIntroEnd(context),
          showSkipButton: true,
          skip: const Text(
            "Skip",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          next: const Text(
            "Next",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          done: const Text(
            "Done",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size(10, 10),
            activeSize: const Size(20, 10),
            activeColor: Colors.green,
            color: Colors.green.withOpacity(0.4),
            spacing: const EdgeInsets.symmetric(horizontal: 3),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ),
    );
  }

  PageDecoration _pageDecoration() {
    return PageDecoration(
      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
      bodyTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      pageColor: Colors.white,
      imagePadding: const EdgeInsets.only(top: 30),
      contentMargin: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
