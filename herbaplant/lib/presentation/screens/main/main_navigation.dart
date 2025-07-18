import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../scan/scan_screen.dart';
import '../history/history_screen.dart'; // ✅ History screen
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
    const HistoryScreen(), // ✅ History screen
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],

      floatingActionButton: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () => _onItemTapped(1), // ScanScreen index
          shape: const CircleBorder(),
          child: const Icon(Icons.center_focus_strong, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: Colors.white,
          elevation: 10,
          notchMargin: 8,
          child: SizedBox(
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home
                SizedBox(
                  height: 30,
                  child: IconButton(
                    icon: Icon(
                      Icons.home_outlined,
                      size: 30,
                      color: _selectedIndex == 0
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                    onPressed: () => _onItemTapped(0),
                  ),
                ),

                // History
                SizedBox(
                  height: 30,
                  child: IconButton(
                    icon: Icon(
                      Icons.history,
                      size: 24,
                      color: _selectedIndex == 2
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                    onPressed: () => _onItemTapped(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
