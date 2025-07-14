import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/main/main_navigation.dart';

void main() {
  runApp(const HerbaPlantApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
    GoRoute(path: '/home', builder: (context, state) => const MainNavigation()),
  ],
);

class HerbaPlantApp extends StatelessWidget {
  const HerbaPlantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
      ),
    );
  }
}
