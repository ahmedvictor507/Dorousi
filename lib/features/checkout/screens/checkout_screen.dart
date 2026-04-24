import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/app_theme.dart';
import '../../../error_handler.dart'; // Import the error handler
import '../../../core/widgets/common_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _promoController = TextEditingController();
  double _discount = 0.0;
  bool _promoApplied = false;
  bool _isProcessing = false;

  // Promo shimmer animation
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmerAnim;

  final double _originalPrice = 150.0;
  double get _totalPrice => _originalPrice * (1 - _discount);

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _shimmerAnim = CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _promoController.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    if (code == 'DOUROUSI20' || code == 'MAROC20') {
      setState(() {
        _discount = 0.20;
        _promoApplied = true;
      });
      // Trigger shimmer on price card
      _shimmerCtrl
        ..reset()
        ..forward();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تطبيق الخصم 20% بنجاح! 🎉'),
          backgroundColor: AppColors.emeraldGreen,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      AppErrorHandler.showError(AppStrings.invalidPromo);
    }
  }

  Future<void> _continueToPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isProcessing = false);
      context.push(AppRoutes.paymentGate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          AppStrings.checkout,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 120),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSectionTitle(title: AppStrings.orderSummary),
              const SizedBox(height: 16),
              _buildOrderCard(),
              const SizedBox(height: 32),
              const AppSectionTitle(title: AppStrings.promoCode),
              const SizedBox(height: 16),
              _buildPromoInput(),
              const SizedBox(height: 32),
              _buildPriceSummary(),
              const SizedBox(height: 24),
              _buildPaymentHint(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget _buildOrderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
        boxShadow: DourousiTheme.softShadow,
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://images.unsplash.com/photo-1543165796-5426273ea4d1?q=80&w=200&auto=format&fit=crop',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.menu_book_rounded,
                    color: AppColors.primaryBlue, size: 32),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('دورة اللغة الإنجليزية الشاملة',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 4),
                Text('أ. مروان بناني',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                SizedBox(height: 8),
                Text('150 د.م.',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                        fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _promoController,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              hintText: 'MAROC20',
              hintStyle: const TextStyle(fontSize: 13, letterSpacing: 1),
              prefixIcon: const Icon(Icons.local_offer_outlined, size: 18),
              suffixIcon: _promoApplied
                  ? const Icon(Icons.check_circle,
                      color: AppColors.emeraldGreen)
                  : null,
              filled: true,
              fillColor: AppColors.inputFill,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(DourousiTheme.kBorderRadius),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: _promoApplied ? null : AppColors.primaryGradient,
            color: _promoApplied ? AppColors.inputFill : null,
            borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
          ),
          child: ElevatedButton(
            onPressed: _promoApplied ? null : _applyPromo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DourousiTheme.kBorderRadius)),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: Text(
              AppStrings.apply,
              style: TextStyle(
                  color: _promoApplied ? AppColors.textTertiary : Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummary() {
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (_, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _promoApplied
                ? AppColors.emeraldGreen
                    .withValues(alpha: 0.05 + _shimmerAnim.value * 0.08)
                : AppColors.primaryBlue.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
            border: Border.all(
              color: _promoApplied
                  ? AppColors.emeraldGreen.withValues(alpha: 0.2)
                  : Colors.transparent,
            ),
          ),
          child: child,
        );
      },
      child: Column(
        children: [
          _buildSummaryRow('المبلغ الأصلي', _originalPrice),
          if (_promoApplied) ...[
            const SizedBox(height: 12),
            _buildSummaryRow('الخصم (20%)', -(_originalPrice * _discount),
                isDiscount: true),
          ],
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.totalPrice,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              AnimatedCounter(
                value: _totalPrice,
                suffix: ' ${AppStrings.currency}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value,
      {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                color: isDiscount
                    ? AppColors.emeraldGreen
                    : AppColors.textSecondary)),
        Text(
          '${value >= 0 ? '' : '-'}${value.abs().toStringAsFixed(0)} ${AppStrings.currency}',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color:
                  isDiscount ? AppColors.emeraldGreen : AppColors.textPrimary),
        ),
      ],
    );
  }

  /// Hint that the next step is payment method selection
  Widget _buildPaymentHint() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.primaryBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'في الخطوة التالية ستختار طريقة الدفع المناسبة لك (بطاقة بنكية، نقداً، أو تحويل بنكي).',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryBlue.withValues(alpha: 0.7),
                  height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
            top: BorderSide(color: AppColors.divider.withValues(alpha: 0.5))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: 56,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 5)),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _continueToPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DourousiTheme.kBorderRadius)),
            ),
            child: _isProcessing
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5))
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'المتابعة لاختيار طريقة الدفع',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 20),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
