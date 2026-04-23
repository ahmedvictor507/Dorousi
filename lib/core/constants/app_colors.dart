import 'package:flutter/material.dart';

/// Centralized color palette for the Dourousi app.
///
/// These colors are derived from the UI/UX design specification
/// targeting the Moroccan student market.
class AppColors {
  AppColors._();

  // ─── Brand Colors ────────────────────────────────────────────────
  /// Deep Blue — Primary brand color
  static const Color primaryBlue = Color(0xFF003366);

  /// Emerald Green — Action / Accent color
  static const Color emeraldGreen = Color(0xFF50C878);

  /// Lighter shade of primary for subtle backgrounds
  static const Color primaryLight = Color(0xFFE8EDF4);

  /// Darker shade of emerald for pressed states
  static const Color emeraldDark = Color(0xFF3DA864);

  // ─── Backgrounds & Surfaces ──────────────────────────────────────
  static const Color background = Color(0xFFFFFFFF);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFFF8F9FA);
  static const Color inputFill = Color(0xFFF5F5F5);

  // ─── Text Colors ─────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Semantic Colors ─────────────────────────────────────────────
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFDECEC);
  static const Color success = Color(0xFF43A047);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFFA726);
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color info = Color(0xFF1E88E5);
  static const Color infoLight = Color(0xFFE3F2FD);

  // ─── Component Colors ────────────────────────────────────────────
  /// "LIVE" badge red
  static const Color liveBadge = Color(0xFFE53935);
  static const Color liveBadgeBg = Color(0x1AE53935); // 10% opacity

  /// Chip / Filter unselected
  static const Color chipUnselected = Color(0xFFF0F0F0);

  /// Divider / Border
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFE0E0E0);

  /// Shimmer / Skeleton
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ─── Premium Gradients ───────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, Color(0xFF0056B3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [emeraldGreen, Color(0xFF3DA864)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumDarkGradient = LinearGradient(
    colors: [Color(0xFF001A33), Color(0xFF003366)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient glassGradient = LinearGradient(
    colors: [
      Colors.white.withValues(alpha: 0.2),
      Colors.white.withValues(alpha: 0.05),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
