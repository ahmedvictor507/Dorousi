import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/app_theme.dart';

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageCtrl = PageController();
  final int _currentPage = 0;

  late AnimationController _iconCtrl;
  late Animation<double> _iconScale;
  late Animation<double> _iconFade;

  final _pages = const [
    _OnboardingPage(
      icon: Icons.live_tv_rounded,
      title: 'حصص مباشرة مع أفضل المعلمين',
      subtitle:
          'انضم إلى آلاف الطلاب في حصص تفاعلية مباشرة مع نخبة من المعلمين المتخصصين في مختلف المواد.',
      gradient: AppColors.primaryGradient,
    ),
    _OnboardingPage(
      icon: Icons.school_rounded,
      title: 'دورات مسجلة تتعلم بوتيرتك',
      subtitle:
          'أكثر من 200 دورة في مختلف المواد الدراسية. ابدأ متى شئت وتعلم بالسرعة التي تناسبك.',
      gradient: LinearGradient(
        colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    _OnboardingPage(
      icon: Icons.person_pin_rounded,
      title: 'احجز حصة خاصة مع معلمك المفضل',
      subtitle:
          'اختر معلمك، حدد المادة والوقت المناسب، وابدأ جلسة خاصة مخصصة لاحتياجاتك فقط.',
      gradient: AppColors.accentGradient,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _iconCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _iconScale = CurvedAnimation(parent: _iconCtrl, curve: Curves.elasticOut);
    _iconFade = CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOut);
    _iconCtrl.forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _iconCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic);
    } else {
      context.go(AppRoutes.login);
    }
  }

  void _animateIcon() {
    _iconCtrl.reset();
    _iconCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(gradient: page.gradient),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: const Text('تخطي',
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w500)),
                ),
              ),

              const Spacer(),

              // Animated icon
              FadeTransition(
                opacity: _iconFade,
                child: ScaleTransition(
                  scale: _iconScale,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3), width: 1.5),
                    ),
                    child: Icon(page.icon, size: 70, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: Text(
                        page.title,
                        key: ValueKey(_currentPage),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: Text(
                        page.subtitle,
                        key: ValueKey('sub_$_currentPage'),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final active = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: active ? 28 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color:
                          active ? Colors.white : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              // Next / Get Started button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              DourousiTheme.kBorderRadius)),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage < _pages.length - 1 ? 'التالي' : 'ابدأ الآن',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
