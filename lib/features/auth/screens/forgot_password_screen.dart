import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

/// Forgot Password Screen
///
/// Step 1 of password recovery flow:
/// - Enter email or phone
/// - Submit to receive verification code
/// - Navigate to verify code screen
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailPhoneController = TextEditingController();

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
    _emailPhoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    authProvider.clearError();

    final success = await authProvider.requestPasswordReset(
      _emailPhoneController.text.trim(),
    );

    if (mounted) {
      if (success) {
        context.push(AppRoutes.verifyCode);
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
                              Icons.lock_reset_rounded,
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
                          AppStrings.forgotPasswordTitle,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'أدخل بريدك الإلكتروني أو رقم هاتفك\nوسنرسل لك رمز التحقق',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ─── Email/Phone Field ────────────
                      AuthTextField(
                        label: AppStrings.phoneOrEmail,
                        hint: 'example@email.com أو 0612345678',
                        controller: _emailPhoneController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.alternate_email_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppStrings.fieldRequired;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      // ─── Submit Button ────────────────
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          return AuthPrimaryButton(
                            text: AppStrings.submit,
                            isLoading: auth.isLoading,
                            onPressed: _handleSubmit,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // ─── Back to Login link ───────────
                      AuthLinkRow(
                        message: 'تذكرت كلمة المرور؟',
                        actionText: AppStrings.login,
                        onTap: () => context.pop(),
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
