import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/app_theme.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildSuccessIcon(),
              const SizedBox(height: 40),
              Text(
                AppStrings.paymentSuccess,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'تم تفعيل دورتك بنجاح. يمكنك الآن البدء في رحلة تعلم مميزة مع أفضل المعلمين.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, height: 1.6),
              ),
              const SizedBox(height: 40),
              _buildOrderInfo(),
              const Spacer(),
              _buildActionButtons(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.emeraldGreen.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.emeraldGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 60,
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildInfoRow('رقم العملية', '#DR-92834'),
          const Divider(height: 24),
          _buildInfoRow('التاريخ', '19 أبريل 2026'),
          const Divider(height: 24),
          _buildInfoRow('المبلغ المدفوع', '120 د.م.'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Container(
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
            onPressed: () => context.go(AppRoutes.courses),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: const Text(
              "ابدأ التعلم الآن",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.go(AppRoutes.home),
          child: const Text('العودة للرئيسية', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
