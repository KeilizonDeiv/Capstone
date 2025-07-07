import 'package:flutter/material.dart';
import 'presentation/screens/main/main_navigation.dart';
import 'presentation/screens/history/prompt_history_screen.dart';

void main() {
  runApp(const HerbaPlantApp());
}

class HerbaPlantApp extends StatelessWidget {
  const HerbaPlantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HerbaPlant',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: MainNavigation(), // 👈 Use navigation wrapper
      routes: {
        '/prompt_history': (_) => PromptHistoryScreen(),
        // Add more routes if needed
      },
    );
  }
}
