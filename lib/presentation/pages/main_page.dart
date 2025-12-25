import 'dart:ui';
import 'package:cosmotiva/presentation/pages/favorites_page.dart';
import 'package:cosmotiva/presentation/pages/history_page.dart';
import 'package:cosmotiva/presentation/pages/profile_page.dart';
import 'package:cosmotiva/presentation/pages/scan_page.dart';
import 'package:cosmotiva/presentation/theme/app_theme.dart';
import 'package:cosmotiva/presentation/widgets/neo_glass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ScanPage(),
    const FavoritesPage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Important for glass effect over body
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        height: 80,
        child: NeoGlassContainer(
          borderRadius: 40,
          blur: 20,
          opacity: 0.1,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.qr_code_scanner, 'Scan', 0),
              _buildNavItem(Icons.favorite_outline, 'Favorites', 1),
              _buildNavItem(Icons.history, 'History', 2),
              _buildNavItem(Icons.person_outline, 'Profile', 3),
            ],
          ),
        ),
      ).animate().slideY(begin: 1, end: 0, duration: 600.ms, curve: Curves.easeOutQuart),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.neonViolet.withOpacity(0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonViolet.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  )
                ],
              )
            : const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.neonTeal : Colors.white.withOpacity(0.5),
          size: 24,
        ),
      ),
    );
  }
}
