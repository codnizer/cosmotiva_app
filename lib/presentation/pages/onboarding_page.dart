
import 'package:cosmotiva/presentation/theme/app_theme.dart';
import 'package:cosmotiva/presentation/viewmodels/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      "title": "Scan Ingredients",
      "description": "Instantly analyze cosmetic products by scanning their ingredient lists.",
      "icon": "scan", // We'll use Icons.qr_code_scanner
    },
    {
      "title": "Personalized Analysis",
      "description": "Get results tailored to your skin type and allergies.",
      "icon": "person", // Icons.face
    },
    {
      "title": "Track History",
      "description": "Keep a record of all your scans and favorite products.",
      "icon": "history", // Icons.history
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidBlack,
      body: Stack(
        children: [
          // Background Elements (Gradients/Orbs)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neonViolet.withOpacity(0.3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonViolet.withOpacity(0.4),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neonTeal.withOpacity(0.3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonTeal.withOpacity(0.4),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          // Glassmorphic Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _slides.length,
                    itemBuilder: (context, index) {
                      return _buildSlide(_slides[index]);
                    },
                  ),
                ),
                _buildIndicators(),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: _buildNextButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(Map<String, String> slide) {
    IconData iconData;
    switch (slide['icon']) {
      case 'scan':
        iconData = Icons.qr_code_scanner;
        break;
      case 'person':
        iconData = Icons.face;
        break;
      case 'history':
        iconData = Icons.history;
        break;
      default:
        iconData = Icons.circle;
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glass Icon Container
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.glassWhite,
                  border: Border.all(color: AppColors.glassBorder),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  iconData,
                  size: 64,
                  color: AppColors.neonTeal,
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            slide['title']!,
            style: AppTextStyles.headerLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            slide['description']!,
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_slides.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? AppColors.neonViolet : AppColors.glassBorder,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: () {
        if (_currentPage < _slides.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          ref.read(onboardingCompletedProvider.notifier).state = true;
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.neonViolet.withOpacity(0.8),
              border: Border.all(color: AppColors.glassBorder),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                _currentPage == _slides.length - 1 ? "Get Started" : "Next",
                style: AppTextStyles.buttonText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
