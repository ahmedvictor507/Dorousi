import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

/// Verify Code Screen
///
/// Step 2 of password recovery:
/// - 6-digit OTP input with auto-focus advance
/// - Resend code option with timer
/// - Verify button with loading state
class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _canResend = false;
  int _resendCountdown = 60;

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

    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendCountdown = 60;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendCountdown--);
      if (_resendCountdown <= 0) {
        setState(() => _canResend = true);
        return false;
      }
      return true;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpCode =>
      _controllers.map((c) => c.text).join();

  Future<void> _handleVerify() async {
    final code = _otpCode;
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يرجى إدخال الرمز كاملاً'),
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

    final success = await authProvider.verifyCode(code);

    if (mounted) {
      if (success) {
        context.push(AppRoutes.resetPassword);
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

  void _onOtpDigitChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Auto-submit when all digits entered
    if (_otpCode.length == 6) {
      _handleVerify();
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
                            Icons.mark_email_read_rounded,
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
                        AppStrings.verificationCode,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'أدخل الرمز المكوّن من 6 أرقام\nالذي أرسلناه إليك',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ─── OTP Input Fields ─────────────
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return Container(
                            width: 48,
                            height: 56,
                            margin: EdgeInsets.only(
                              left: index < 5 ? 8 : 0,
                            ),
                            child: TextFormField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryBlue,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: _controllers[index].text.isNotEmpty
                                    ? AppColors.primaryLight
                                    : AppColors.inputFill,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primaryBlue,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onChanged: (value) =>
                                  _onOtpDigitChanged(value, index),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ─── Verify Button ────────────────
                    Consumer<AuthProvider>(
                      builder: (context, auth, _) {
                        return AuthPrimaryButton(
                          text: 'تحقق',
                          isLoading: auth.isLoading,
                          onPressed: _handleVerify,
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // ─── Resend Code ──────────────────
                    Center(
                      child: _canResend
                          ? GestureDetector(
                              onTap: () {
                                _startResendTimer();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('تم إرسال الرمز مجدداً'),
                                    backgroundColor: AppColors.success,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'إعادة إرسال الرمز',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            )
                          : Text(
                              'إعادة الإرسال بعد $_resendCountdown ثانية',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                            ),
                    ),

                    const SizedBox(height: 40),
                  ],
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
