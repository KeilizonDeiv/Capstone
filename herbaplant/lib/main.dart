import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';
import 'package:herbaplant/presentation/screens/profile/profilesettings/app_settings.dart';
import 'package:provider/provider.dart';
import 'routes/routes.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:herbaplant/presentation/screens/profile/profilesettings/app_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appLinks = AppLinks();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettings(),
      child: HerbaPlantApp(appLinks: appLinks),
    ),
  );
}

class HerbaPlantApp extends StatefulWidget {
  final AppLinks appLinks;
  const HerbaPlantApp({super.key, required this.appLinks});

  @override
  State<HerbaPlantApp> createState() => _HerbaPlantAppState();
}

class _HerbaPlantAppState extends State<HerbaPlantApp> {
  late final GoRouter _router;
  StreamSubscription<Uri?>? _sub;

  @override
  void initState() {
    super.initState();
    _router = createRouter();

    _sub = widget.appLinks.uriLinkStream.listen((uri) {
      if (uri != null && navigatorKey.currentContext != null) {
        final query = uri.hasQuery ? '?${uri.query}' : '';
        var path = uri.path.isNotEmpty ? uri.path : '/reset-password';

        if (path.endsWith('/')) path = path.substring(0, path.length - 1);

        final location = '$path$query';
        debugPrint("📩 Runtime deep link received: $location");
        _router.go(location);
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
    final settings = Provider.of<AppSettings>(context);

    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}