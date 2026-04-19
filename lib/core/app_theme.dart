import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/app_colors.dart';

/// Dourousi Design System
///
/// All design tokens are centralized here per the UI/UX spec:
/// - Primary: Deep Blue (#003366)
/// - Accent:  Emerald Green (#50C878)
/// - Background: White (#FFFFFF)
/// - Border Radius: 16.0 globally
/// - Shadows: Soft (0.05 opacity, blurRadius 10)
class DourousiTheme {
  DourousiTheme._();

  // ─── Border Radius ───────────────────────────────────────────────
  static const double kBorderRadius = 16.0;
  static final BorderRadius kCardRadius = BorderRadius.circular(kBorderRadius);
  static final BorderRadius kButtonRadius =
      BorderRadius.circular(kBorderRadius);
  static const BorderRadius kBottomSheetRadius = BorderRadius.only(
    topLeft: Radius.circular(kBorderRadius + 8),
    topRight: Radius.circular(kBorderRadius + 8),
  );

  // ─── Shadows ─────────────────────────────────────────────────────
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  // ─── Spacing ─────────────────────────────────────────────────────
  static const double kPaddingXS = 4.0;
  static const double kPaddingSM = 8.0;
  static const double kPaddingMD = 16.0;
  static const double kPaddingLG = 20.0;
  static const double kPaddingXL = 24.0;
  static const double kPaddingXXL = 32.0;

  // ─── Text Theme ──────────────────────────────────────────────────
  static TextTheme _buildTextTheme() {
    return GoogleFonts.tajawalTextTheme(
      const TextTheme(
        // Display
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryBlue,
          height: 1.3,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryBlue,
          height: 1.3,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
          height: 1.3,
        ),
        // Headlines
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryBlue,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
        // Titles
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        // Body
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        // Labels
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  // ─── Light Theme ─────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final textTheme = _buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        onPrimary: Colors.white,
        secondary: AppColors.emeraldGreen,
        onSecondary: Colors.white,
        surface: AppColors.surfaceWhite,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        titleTextStyle:
            textTheme.headlineSmall?.copyWith(color: AppColors.primaryBlue),
        iconTheme: const IconThemeData(color: AppColors.primaryBlue),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emeraldGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius)),
          elevation: 0,
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textTertiary,
        elevation: 12,
      ),
    );
  }

  // ─── Dark Theme ──────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final textTheme = _buildTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF001A33),
      textTheme: textTheme,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4D94FF),
        onPrimary: Colors.white,
        secondary: AppColors.emeraldGreen,
        onSecondary: Colors.white,
        surface: Color(0xFF00264D),
        onSurface: Colors.white,
        error: Colors.redAccent,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF001A33),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.headlineSmall?.copyWith(color: Colors.white),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emeraldGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius)),
          elevation: 0,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: Color(0xFF4D94FF), width: 1.5),
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF001A33),
        selectedItemColor: Color(0xFF4D94FF),
        unselectedItemColor: Colors.white54,
        elevation: 8,
      ),
    );
  }

  // ─── Glassmorphism Decoration ────────────────────────────────────
  static BoxDecoration glassDecoration(
      {double opacity = 0.1, double blur = 10}) {
    return BoxDecoration(
      color: Colors.white.withOpacity(opacity),
      borderRadius: kCardRadius,
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    );
  }
}
