import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentIndex = 0;
  final TextEditingController _promoController = TextEditingController();
  double _discount = 0.0;
  bool _promoApplied = false;
  bool _isProcessing = false;

  final double _originalPrice = 150.0;

  double get _totalPrice => _originalPrice * (1 - _discount);

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    if (code == "DOUROUSI20" || code == "MAROC20") {
      setState(() {
        _discount = 0.20;
        _promoApplied = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تطبيق الخصم بنجاح!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.invalidPromo)),
      );
    }
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    // Simulate processing
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go(AppRoutes.paymentSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.checkout),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(AppStrings.orderSummary),
            const SizedBox(height: 16),
            _buildOrderCard(),
            const SizedBox(height: 32),
            _buildSectionTitle(AppStrings.promoCode),
            const SizedBox(height: 12),
            _buildPromoInput(),
            const SizedBox(height: 32),
            _buildSectionTitle(AppStrings.paymentMethod),
            const SizedBox(height: 12),
            _buildPaymentMethods(),
            const SizedBox(height: 32),
            _buildPriceSummary(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: _buildBottomAction(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildOrderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: DourousiTheme.softShadow,
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
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('دورة اللغة الإنجليزية الشاملة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 4),
                Text('أ. مروان بناني', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                SizedBox(height: 8),
                Text('150.0 د.م.', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryBlue)),
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
            decoration: InputDecoration(
              hintText: 'أدخل رمز الخصم (مثال: MAROC20)',
              hintStyle: const TextStyle(fontSize: 12),
              suffixIcon: _promoApplied ? const Icon(Icons.check_circle, color: AppColors.emeraldGreen) : null,
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _promoApplied ? null : _applyPromo,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(80, 52),
            backgroundColor: AppColors.primaryBlue,
          ),
          child: const Text(AppStrings.apply),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    final List<Map<String, dynamic>> methods = [
      {'name': AppStrings.cmiCard, 'icon': Icons.credit_card_rounded},
      {'name': AppStrings.creditCard, 'icon': Icons.public_rounded},
      {'name': AppStrings.cashPayment, 'icon': Icons.payments_rounded},
    ];

    return Column(
      children: List.generate(methods.length, (index) {
        final isSelected = _selectedPaymentIndex == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => setState(() => _selectedPaymentIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primaryBlue : AppColors.divider.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(methods[index]['icon'], color: isSelected ? AppColors.primaryBlue : AppColors.textTertiary),
                  const SizedBox(width: 16),
                  Text(
                    methods[index]['name'],
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected) const Icon(Icons.check_circle, color: AppColors.primaryBlue, size: 20),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildSummaryRow('المبلغ الأصلي', '${_originalPrice.toStringAsFixed(0)} د.م.'),
          if (_promoApplied) ...[
            const SizedBox(height: 12),
            _buildSummaryRow('الخصم (20%)', '-${(_originalPrice * _discount).toStringAsFixed(0)} د.م.', isDiscount: true),
          ],
          const Divider(height: 32),
          _buildSummaryRow(AppStrings.totalPrice, '${_totalPrice.toStringAsFixed(0)} د.م.', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount ? AppColors.emeraldGreen : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 22 : 16,
            fontWeight: FontWeight.bold,
            color: isDiscount ? AppColors.emeraldGreen : (isTotal ? AppColors.primaryBlue : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: AppColors.divider.withOpacity(0.5))),
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: AppColors.primaryBlue.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
            ),
            child: _isProcessing
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text(
                    AppStrings.confirmPayment,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }
}
