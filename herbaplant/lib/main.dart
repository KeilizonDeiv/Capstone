import 'package:flutter/material.dart';
import 'package:herbaplant/routes/routes.dart'; // ✅ Import your central router here

void main() {
  runApp(const HerbaPlantApp());
}

class HerbaPlantApp extends StatelessWidget {
  const HerbaPlantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router, // ✅ Use the router from app_router.dart
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
      ),
    );
  }
}
