import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/app_theme.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _circleCtrl;
  late AnimationController _checkCtrl;
  late AnimationController _contentCtrl;

  late Animation<double> _circleScale;
  late Animation<double> _circleFade;
  late Animation<double> _checkDraw;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    // 1. Circle scales in
    _circleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _circleScale = CurvedAnimation(
        parent: _circleCtrl, curve: Curves.elasticOut);
    _circleFade = CurvedAnimation(
        parent: _circleCtrl, curve: Curves.easeOut);

    // 2. Checkmark draws itself
    _checkCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _checkDraw = CurvedAnimation(
        parent: _checkCtrl, curve: Curves.easeInOut);

    // 3. Content fades up
    _contentCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _contentFade = CurvedAnimation(
        parent: _contentCtrl, curve: Curves.easeOut);
    _contentSlide = Tween<Offset>(
            begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOutCubic));

    // Sequence: circle → check → content
    _circleCtrl.forward().then((_) {
      _checkCtrl.forward().then((_) {
        _contentCtrl.forward();
      });
    });
  }

  @override
  void dispose() {
    _circleCtrl.dispose();
    _checkCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryBlue.withValues(alpha: 0.03),
              Theme.of(context).scaffoldBackgroundColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // ── Animated check icon ──
                FadeTransition(
                  opacity: _circleFade,
                  child: ScaleTransition(
                    scale: _circleScale,
                    child: _buildAnimatedCheck(),
                  ),
                ),

                const SizedBox(height: 40),

                // ── Animated content ──
                FadeTransition(
                  opacity: _contentFade,
                  child: SlideTransition(
                    position: _contentSlide,
                    child: Column(
                      children: [
                        Text(
                          AppStrings.paymentSuccess,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryBlue,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'تم تفعيل دورتك بنجاح. يمكنك الآن البدء في رحلة تعلم مميزة مع أفضل المعلمين.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.textSecondary, height: 1.6, fontSize: 15),
                        ),
                        const SizedBox(height: 36),
                        _buildOrderInfo(),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // ── Action buttons ──
                FadeTransition(
                  opacity: _contentFade,
                  child: _buildActionButtons(context),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCheck() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.emeraldGreen.withValues(alpha: 0.12),
          ),
        ),
        // Middle ring
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.emeraldGreen.withValues(alpha: 0.2),
          ),
        ),
        // Inner filled circle
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.accentGradient,
          ),
          child: AnimatedBuilder(
            animation: _checkDraw,
            builder: (_, __) {
              return CustomPaint(
                painter: _CheckmarkPainter(progress: _checkDraw.value),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.tag_rounded, 'رقم العملية', '#DR-92834'),
          const Divider(height: 24),
          _buildInfoRow(Icons.calendar_today_rounded, 'التاريخ', '19 أبريل 2026'),
          const Divider(height: 24),
          _buildInfoRow(Icons.payments_rounded, 'المبلغ المدفوع',
              '120 ${AppStrings.currency}'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryBlue),
        const SizedBox(width: 10),
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold)),
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
            borderRadius:
                BorderRadius.circular(DourousiTheme.kBorderRadius),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 5)),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => context.go(AppRoutes.courses),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      DourousiTheme.kBorderRadius)),
            ),
            child: const Text(
              'ابدأ التعلم الآن',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.go(AppRoutes.home),
          child: const Text('العودة للرئيسية',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}

// ── Custom checkmark painter ──────────────────────────────────────────────────

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  const _CheckmarkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Check path: from bottom-left to middle, then up-right
    final path = Path()
      ..moveTo(cx - 14, cy)
      ..lineTo(cx - 4, cy + 10)
      ..lineTo(cx + 14, cy - 10);

    final pathMetrics = path.computeMetrics().first;
    final drawn = pathMetrics.extractPath(
        0, pathMetrics.length * progress.clamp(0.0, 1.0));
    canvas.drawPath(drawn, paint);
  }

  @override
  bool shouldRepaint(_CheckmarkPainter old) => old.progress != progress;
}
