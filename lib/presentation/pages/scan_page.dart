import 'package:cosmotiva/presentation/pages/product_page.dart';
import 'package:cosmotiva/presentation/theme/app_theme.dart';
import 'package:cosmotiva/presentation/viewmodels/scan_viewmodel.dart';
import 'package:cosmotiva/presentation/viewmodels/providers.dart';
import 'package:cosmotiva/presentation/widgets/neo_glass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class ScanPage extends ConsumerWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanViewModelProvider);

    // Listen for state changes to navigate
    ref.listen(scanViewModelProvider, (previous, next) {
      if (next is ScanSuccess) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductPage(product: next.product),
          ),
        );
      } else if (next is ScanError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
            backgroundColor: AppTheme.darkTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.voidBlack,
                  AppColors.midnightBlue,
                  Color(0xFF1A0525), // Deep purple hint
                ],
              ),
            ),
          ),
          
          // Ambient Glows (Top Left)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neonViolet.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonViolet.withOpacity(0.2),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 4.seconds),

          // Ambient Glows (Bottom Right)
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neonTeal.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonTeal.withOpacity(0.15),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3), duration: 5.seconds),

          // ---------------------------------------------------------
          // UPDATED CREDIT DISPLAY (SafeArea + Better Logic)
          // ---------------------------------------------------------
          Positioned(
            top: 0, 
            right: 0,
            child: SafeArea( // Ensures it doesn't hide behind the notch
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 20),
                child: Consumer(
                  builder: (context, ref, child) {
                    final user = ref.watch(authServiceProvider).currentUser;
                    if (user == null) return const SizedBox.shrink();
                    
                    final userProfileAsync = ref.watch(userProfileStreamProvider(user.uid));
                    
                    return userProfileAsync.when(
                      data: (profile) {
                        final credits = profile?.dailyCredits ?? 0;
                        
                        // FIX: Show "Watch Ad" button if credits are low (< 3), not just 0.
                        // This allows users to top up before they run out completely.
                        final isLow = credits < 3; 
                        final isZero = credits == 0;
                        
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NeoGlassContainer(
                              width: null,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              borderRadius: 20,
                              color: isZero ? AppColors.neonRed : Colors.white,
                              borderColor: isZero ? AppColors.neonRed.withOpacity(0.5) : null,
                              child: Text(
                                '⚡ Credits: $credits',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isZero ? AppColors.neonRed : AppColors.neonTeal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isLow) ...[
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  // Ensure AdService is updated to pre-load ads as discussed previously
                                  ref.read(adServiceProvider).showRewardedAd(() {
                                    ref.read(userRepositoryProvider).incrementCredits(user.uid);
                                  });
                                },
                                child: NeoGlassContainer(
                                  width: null,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  borderRadius: 20,
                                  color: AppColors.neonViolet.withOpacity(0.2),
                                  borderColor: AppColors.neonViolet,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.play_circle_outline, color: Colors.white, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        '+1',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1.seconds), // Add pulse animation to draw attention
                            ],
                          ],
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    );
                  },
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (scanState is ScanLoading) ...[
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.glassWhite,
                          border: Border.all(color: AppColors.neonViolet.withOpacity(0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.neonViolet.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: Lottie.asset(
                          'assets/lottie/scan.json',
                          width: 150,
                          height: 150,
                          errorBuilder: (context, error, stackTrace) {
                            return const CircularProgressIndicator(color: AppColors.neonTeal);
                          },
                        ),
                      ),
                    ).animate().fadeIn().scale(),
                    const SizedBox(height: 40),
                    Text(
                      'ANALYZING MOLECULAR STRUCTURE...',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.neonTeal,
                        letterSpacing: 2,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate(onPlay: (c) => c.repeat())
                     .shimmer(duration: 2.seconds, color: Colors.white),
                  ] else ...[
                    const Spacer(),
                    NeoGlassContainer(
                      padding: const EdgeInsets.all(20),
                      borderRadius: 30,
                      child: Column(
                        children: [
                          Text(
                            'COSMOTIVA',
                            style: AppTextStyles.headerLarge.copyWith(
                              fontWeight: FontWeight.w200,
                              letterSpacing: 4,
                            ),
                          ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.5, end: 0),
                          const SizedBox(height: 10),
                          Text(
                            'Reveal the truth behind the label.',
                            style: AppTextStyles.bodyLarge,
                            textAlign: TextAlign.center,
                          ).animate().fadeIn(delay: 300.ms),
                        ],
                      ),
                    ),
                    const Spacer(),
                    HolographicButton(
                      text: 'Scan with Camera',
                      icon: Icons.camera_alt_outlined,
                      onTap: () => ref.read(scanViewModelProvider.notifier).pickImage(ImageSource.camera),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5, end: 0),
                    const SizedBox(height: 20),
                    HolographicButton(
                      text: 'Upload from Gallery',
                      icon: Icons.photo_library_outlined,
                      isPrimary: false,
                      onTap: () => ref.read(scanViewModelProvider.notifier).pickImage(ImageSource.gallery),
                    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.5, end: 0),
                    const SizedBox(height: 50),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}