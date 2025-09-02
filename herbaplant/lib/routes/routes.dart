import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:herbaplant/presentation/screens/auth/reset_password_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/main/main_navigation.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/profile/edit_profile_screen.dart';
// import '../presentation/screens/history/prompt_history_screen.dart';
import '../presentation/screens/profile/profilesettings/about_screen.dart';
import '../presentation/screens/profile/profilesettings/settings_screen.dart';
import '../presentation/screens/profile/profilesettings/help_screen.dart';
import '../presentation/screens/history/history_screen.dart';

/// Global navigator key (used for deep links & programmatic navigation)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Factory function to create the router with dynamic initialLocation.
/// - Normal launch → initialLocation = '/'
/// - Deep link launch (e.g. herbaplant://reset-password?token=123)
///   → initialLocation = '/reset-password?token=123'
GoRouter createRouter() {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => SplashScreen(), // we’ll update next
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return ResetPasswordScreen(token: token);
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainNavigation(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutHerbaPlantScreen(),
      ),
    ],
    redirect: (context, state) {
      final loc = state.uri.toString();

      // 🩹 Normalize trailing slash for reset-password
      if (loc.startsWith('/reset-password/')) {
        final fixed = loc.replaceFirst('/reset-password/', '/reset-password');
        return fixed;
      }

      return null;
    },
    debugLogDiagnostics: true,
  );
}
