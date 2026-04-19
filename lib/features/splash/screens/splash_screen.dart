import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/connectivity_service.dart';
import '../../auth/providers/auth_provider.dart';

/// Splash Screen
///
/// Entry point of the app. Performs:
/// 1. Branded logo animation (fade + scale)
/// 2. Internet connectivity check
/// 3. Auth state check → routes to Login or Home
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _subtitleFade;

  bool _showNoInternet = false;
  bool _isChecking = false;
  final ConnectivityService _connectivity = ConnectivityService();

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );

    _animController.forward();
    _startChecks();
  }

  Future<void> _startChecks() async {
    setState(() {
      _isChecking = true;
      _showNoInternet = false;
    });

    // Let the animation play for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Check connectivity
    final hasConnection = await _connectivity.hasConnection();

    if (!hasConnection) {
      if (mounted) {
        setState(() {
          _showNoInternet = true;
          _isChecking = false;
        });
      }
      return;
    }

    // Check auth state
    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.checkLoginState();

      if (mounted) {
        if (authProvider.isLoggedIn) {
          context.go(AppRoutes.home);
        } else {
          context.go(AppRoutes.login);
        }
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryBlue,
              Color(0xFF001A33),
            ],
          ),
        ),
        child: Stack(
          children: [
            // ─── Decorative circles ──────────────────
            Positioned(
              top: -80,
              right: -60,
              child: _buildDecorativeCircle(200, 0.06),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: _buildDecorativeCircle(250, 0.04),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: -40,
              child: _buildDecorativeCircle(120, 0.03),
            ),

            // ─── Main content ────────────────────────
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / App Icon
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.emeraldGreen.withOpacity(0.3),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.auto_stories_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // App name
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: child,
                      );
                    },
                    child: const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _subtitleFade.value,
                        child: child,
                      );
                    },
                    child: Text(
                      'منصتك التعليمية الأولى في المغرب',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Loading or error state
                  if (_isChecking && !_showNoInternet)
                    _buildLoadingIndicator(),
                ],
              ),
            ),

            // ─── No Internet Overlay ────────────────
            if (_showNoInternet) _buildNoInternetOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            color: AppColors.emeraldGreen,
            strokeWidth: 3,
            backgroundColor: Colors.white.withOpacity(0.1),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'جاري التحميل...',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildNoInternetOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated icon
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.wifi_off_rounded,
                      size: 40,
                      color: AppColors.error,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  AppStrings.noInternet,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  AppStrings.noInternetDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 28),

                // Retry button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _startChecks,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.refresh_rounded, size: 20),
                        SizedBox(width: 8),
                        Text(
                          AppStrings.retry,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
