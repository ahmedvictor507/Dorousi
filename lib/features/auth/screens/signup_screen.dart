import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

/// Signup Screen
///
/// Features:
/// - Full name, phone/email, password, confirm password
/// - Terms & conditions checkbox
/// - Validation on all fields
/// - Animated form entrance
/// - Link back to login
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptedTerms = false;

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
      begin: const Offset(0, 0.2),
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
    _nameController.dispose();
    _emailPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يرجى قبول الشروط والأحكام'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    authProvider.clearError();

    final success = await authProvider.signup(
      fullName: _nameController.text.trim(),
      emailOrPhone: _emailPhoneController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
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

                      const SizedBox(height: 24),

                      // ─── Header ───────────────────────
                      _buildHeaderSection(),

                      const SizedBox(height: 32),

                      // ─── Full Name ────────────────────
                      AuthTextField(
                        label: AppStrings.fullName,
                        hint: 'محمد أحمد',
                        controller: _nameController,
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppStrings.fieldRequired;
                          }
                          if (value.trim().length < 3) {
                            return 'الاسم قصير جداً';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // ─── Email / Phone ────────────────
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

                      const SizedBox(height: 20),

                      // ─── Password ─────────────────────
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

                      const SizedBox(height: 20),

                      // ─── Terms & Conditions ───────────
                      _buildTermsCheckbox(),

                      const SizedBox(height: 28),

                      // ─── Create Account Button ────────
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          return AuthPrimaryButton(
                            text: AppStrings.createAccount,
                            isLoading: auth.isLoading,
                            onPressed: _handleSignup,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // ─── Login Link ───────────────────
                      AuthLinkRow(
                        message: AppStrings.alreadyHaveAccount,
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

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Accent decoration
        Container(
          width: 50,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.emeraldGreen,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.createAccount,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'أنشئ حسابك وابدأ رحلتك التعليمية',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return GestureDetector(
      onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _acceptedTerms ? AppColors.emeraldGreen : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _acceptedTerms
                    ? AppColors.emeraldGreen
                    : AppColors.textTertiary,
                width: 2,
              ),
            ),
            child: _acceptedTerms
                ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                children: const [
                  TextSpan(text: 'أوافق على '),
                  TextSpan(
                    text: 'الشروط والأحكام',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: ' و'),
                  TextSpan(
                    text: 'سياسة الخصوصية',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
