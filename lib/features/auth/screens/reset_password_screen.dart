import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

/// Reset Password Screen
///
/// Step 3 (final) of password recovery:
/// - New password + confirm password
/// - Success → navigate back to login
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showSuccess = false;

  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    authProvider.clearError();

    final success = await authProvider.resetPassword(
      _passwordController.text,
      _confirmPasswordController.text,
    );

    if (mounted) {
      if (success) {
        setState(() => _showSuccess = true);

        // Auto-navigate to login after 2.5 seconds
        await Future.delayed(const Duration(milliseconds: 2500));
        if (mounted) {
          context.go(AppRoutes.login);
        }
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
    if (_showSuccess) return _buildSuccessView();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SlideTransition(
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
                      const SizedBox(height: 16),

                      // ─── Back button ──────────────────
                      _buildBackButton(),

                      const SizedBox(height: 40),

                      // ─── Illustration ─────────────────
                      Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: 1.0),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(scale: value, child: child);
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.password_rounded,
                              size: 48,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ─── Title ────────────────────────
                      Center(
                        child: Text(
                          AppStrings.newPassword,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'أنشئ كلمة مرور جديدة\nيجب أن تكون 6 أحرف على الأقل',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ─── New Password ─────────────────
                      AuthTextField(
                        label: AppStrings.newPassword,
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

                      const SizedBox(height: 20),

                      // ─── Confirm Password ─────────────
                      AuthTextField(
                        label: AppStrings.confirmPassword,
                        hint: '••••••••',
                        controller: _confirmPasswordController,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.fieldRequired;
                          }
                          if (value != _passwordController.text) {
                            return AppStrings.passwordMismatch;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      // ─── Password strength indicator ──
                      _buildPasswordStrength(),

                      const SizedBox(height: 32),

                      // ─── Reset Button ─────────────────
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          return AuthPrimaryButton(
                            text: AppStrings.confirm,
                            isLoading: auth.isLoading,
                            onPressed: _handleReset,
                          );
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordStrength() {
    final password = _passwordController.text;
    int strength = 0;
    if (password.length >= 6) strength++;
    if (password.length >= 8) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;

    final colors = [
      AppColors.error,
      AppColors.warning,
      AppColors.emeraldGreen.withOpacity(0.7),
      AppColors.emeraldGreen,
    ];

    final labels = ['ضعيفة', 'متوسطة', 'جيدة', 'قوية'];

    if (password.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                margin: EdgeInsets.only(left: index < 3 ? 6 : 0),
                decoration: BoxDecoration(
                  color: index < strength
                      ? colors[strength - 1]
                      : AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        if (strength > 0)
          Text(
            'قوة كلمة المرور: ${labels[strength - 1]}',
            style: TextStyle(
              fontSize: 12,
              color: colors[strength - 1],
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildSuccessView() {
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
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success checkmark
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.emeraldGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emeraldGreen.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'تم تغيير كلمة المرور بنجاح!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'جاري إعادتك لصفحة الدخول...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    color: AppColors.emeraldGreen,
                    strokeWidth: 3,
                    backgroundColor: Colors.white.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surfaceGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.primaryBlue,
          size: 18,
        ),
      ),
    );
  }
}
