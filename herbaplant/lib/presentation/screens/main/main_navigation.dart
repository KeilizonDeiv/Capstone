import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../scan/scan_screen.dart';
import '../chatbot/chatbot_screen.dart';
import '../../../core/constants/app_colors.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ScanScreen(),
    const ChatbotScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Needed for FAB overlap effect
      body: _screens[_selectedIndex],

      /// Floating SCAN Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _onItemTapped(1),
        shape: const CircleBorder(),
        child: const Icon(Icons.center_focus_strong, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      /// Custom Bottom Navigation
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomAppBar(
          color: Colors.white,
          elevation: 10,
          shape: const CircularNotchedRectangle(),
          notchMargin: 7,
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home Button
                IconButton(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 30,
                    color: _selectedIndex == 0 ? AppColors.primary : Colors.grey,
                  ),
                  onPressed: () => _onItemTapped(0),
                ),

                const SizedBox(width: 48), // Space for center FAB

                // Chatbot Button
                IconButton(
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    size: 28,
                    color: _selectedIndex == 2 ? AppColors.primary : Colors.grey,
                  ),
                  onPressed: () => _onItemTapped(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
