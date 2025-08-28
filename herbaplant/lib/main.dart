import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';
import 'routes/routes.dart'; // your createRouter + navigatorKey

StreamSubscription<Uri?>? _sub;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appLinks = AppLinks();
  final initialUri = await appLinks.getInitialAppLink();

  // Default → splash
  String initialLocation = '/';
    if (initialUri != null) {
      if (initialUri.path.isNotEmpty) {
        initialLocation = initialUri.path +
            (initialUri.hasQuery ? '?${initialUri.query}' : '');
      } else if (initialUri.queryParameters.containsKey('token')) {
        initialLocation =
            '/reset-password?token=${initialUri.queryParameters['token']}';
      }
    }

  print("🚀 Starting app at $initialLocation");

  runApp(HerbaPlantApp(
    initialLocation: initialLocation,
    appLinks: appLinks,
  ));
}


class HerbaPlantApp extends StatefulWidget {
  final String initialLocation;
  final AppLinks appLinks;

  const HerbaPlantApp({
    super.key,
    required this.initialLocation,
    required this.appLinks,
  });

  @override
  State<HerbaPlantApp> createState() => _HerbaPlantAppState();
}

class _HerbaPlantAppState extends State<HerbaPlantApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    // 👇 build router with initial deep link location
    _router = createRouter(initialLocation: widget.initialLocation);

    // 👇 runtime deep link listener (warm start)
    _sub = widget.appLinks.uriLinkStream.listen((uri) {
      if (uri != null && navigatorKey.currentContext != null) {
        String path;
        if (uri.path.isNotEmpty) {
          path = uri.path + (uri.hasQuery ? '?${uri.query}' : '');
        } else if (uri.queryParameters.containsKey('token')) {
          path = '/reset-password?token=${uri.queryParameters['token']}';
        } else {
          path = '/';
        }

        debugPrint("📩 Runtime deep link received: $path");
        GoRouter.of(navigatorKey.currentContext!).go(path);
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

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
