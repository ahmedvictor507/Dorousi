import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

/// Login Screen
///
/// Features:
/// - Branded header with wave decoration
/// - Phone/email + password fields
/// - Forgot password link
/// - Login button with loading state
/// - Sign up link at bottom
/// - Error display via SnackBar
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    authProvider.clearError();

    final success = await authProvider.login(
      emailOrPhone: _emailPhoneController.text.trim(),
      password: _passwordController.text,
    );

    if (mounted) {
      if (success) {
        context.go(AppRoutes.home);
      } else if (authProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ─── Branded Header ─────────────────────────
            _buildHeader(screenHeight),

            // ─── Form Section ───────────────────────────
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),

                        // Welcome text
                        Text(
                          AppStrings.login,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'مرحباً بعودتك! سجّل دخولك للمتابعة',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),

                        const SizedBox(height: 32),

                        // Email / Phone field
                        AuthTextField(
                          label: AppStrings.phoneOrEmail,
                          hint: 'example@email.com أو 0612345678',
                          controller: _emailPhoneController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.person_outline_rounded,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.fieldRequired;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Password field
                        AuthTextField(
                          label: AppStrings.password,
                          hint: '••••••••',
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline_rounded,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.fieldRequired;
                            }
                            if (value.length < 6) {
                              return AppStrings.passwordTooShort;
                            }
                            return null;
                          },
                        ),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () => context.push(AppRoutes.forgotPassword),
                            child: const Text(
                              AppStrings.forgotPassword,
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Login button
                        Consumer<AuthProvider>(
                          builder: (context, auth, _) {
                            return AuthPrimaryButton(
                              text: AppStrings.login,
                              isLoading: auth.isLoading,
                              onPressed: _handleLogin,
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // Divider with "or"
                        Row(
                          children: [
                            Expanded(
                              child: Divider(color: Colors.grey.shade200),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'أو',
                                style: TextStyle(
                                  color: AppColors.textTertiary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: Colors.grey.shade200),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Sign up link
                        AuthLinkRow(
                          message: AppStrings.dontHaveAccount,
                          actionText: AppStrings.createAccount,
                          onTap: () => context.push(AppRoutes.signup),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double screenHeight) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.3,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryBlue,
            Color(0xFF004080),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            top: -30,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 40,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emeraldGreen.withOpacity(0.15),
              ),
            ),
          ),

          // Logo + Title
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
