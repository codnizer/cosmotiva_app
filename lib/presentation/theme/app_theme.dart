import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Core Backgrounds
  static const Color voidBlack = Color(0xFF050505);
  static const Color midnightBlue = Color(0xFF0A0E21);
  
  // Accents
  static const Color neonTeal = Color(0xFF00F0FF);
  static const Color neonViolet = Color(0xFFBD00FF);
  static const Color neonRed = Color(0xFFFF0055);
  static const Color electricBlue = Color(0xFF2D6CDF);
  
  // Utility
  static const Color glassWhite = Color(0x1AFFFFFF); // 10% White
  static const Color glassBorder = Color(0x33FFFFFF); // 20% White
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% White
}

class AppTextStyles {
  static TextStyle get headerLarge => GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w300, // Light weight for cinematic feel
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get headerMedium => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  
  static TextStyle get buttonText => GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.voidBlack,
      primaryColor: AppColors.neonViolet,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonViolet,
        secondary: AppColors.neonTeal,
        surface: AppColors.midnightBlue,
        background: AppColors.voidBlack,
        error: Color(0xFFFF3366),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headerLarge,
        displayMedium: AppTextStyles.headerMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
      ),
      // Remove default splashes for custom implementation
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
