import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';

class BookingScreen extends StatefulWidget {
  final String teacherId;
  const BookingScreen({super.key, required this.teacherId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with TickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTime;
  String? _selectedSubject;

  late AnimationController _contentCtrl;
  late Animation<double> _contentFade;

  final List<String> _subjects = ['رياضيات', 'فيزياء', 'علوم حاسوب'];
  final List<String> _timeSlots = [
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
    '07:00 PM',
    '08:00 PM'
  ];

  @override
  void initState() {
    super.initState();
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _contentFade = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _contentCtrl.forward();
    });
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── FIX: titlePadding includes left offset for back button ──
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            elevation: 0,
            stretch: true,
            backgroundColor: AppColors.primaryBlue,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 18),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              // Using directional padding for RTL compatibility
              titlePadding: const EdgeInsetsDirectional.only(
                  start: 64, end: 16, bottom: 16),
              title: const Text(
                AppStrings.bookPrivate,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                  ),
                  // Decorative watermark
                  const Positioned(
                    right: -30,
                    top: -30,
                    child: Opacity(
                      opacity: 0.08,
                      child: Icon(
                        Icons.school_rounded,
                        size: 220,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Subtle bottom fade into content
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withValues(alpha: 0.4),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Animated main content ──
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _contentFade,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildTeacherSummary(),
                    const SizedBox(height: 32),
                    const AppSectionTitle(title: AppStrings.selectSubject),
                    const SizedBox(height: 12),
                    _buildSubjectPicker(),
                    const SizedBox(height: 32),
                    const AppSectionTitle(title: AppStrings.selectDate),
                    const SizedBox(height: 12),
                    _buildDateCalendar(),
                    const SizedBox(height: 32),
                    const AppSectionTitle(title: AppStrings.selectTime),
                    const SizedBox(height: 12),
                    _buildTimePicker(),
                    const SizedBox(height: 140),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomAction(),
    );
  }

  Widget _buildTeacherSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: const CircleAvatar(
              radius: 28,
              backgroundImage:
                  NetworkImage('https://i.pravatar.cc/150?u=yassine'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'أ. ياسين الإدريسي',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'خبير علوم الحاسوب • 5.0',
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.info_outline_rounded,
                  color: AppColors.primaryBlue),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSubject,
          hint: const Text(AppStrings.selectSubject,
              style: TextStyle(fontSize: 14)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.primaryBlue),
          borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
          items: _subjects
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (val) => setState(() => _selectedSubject = val),
        ),
      ),
    );
  }

  Widget _buildDateCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
        boxShadow: DourousiTheme.softShadow,
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: CalendarDatePicker(
            initialDate: _selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 90)),
            onDateChanged: (date) => setState(() => _selectedDate = date),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _timeSlots.asMap().entries.map((entry) {
        final time = entry.value;
        final isSelected = _selectedTime == time;
        return _TimeChip(
          time: time,
          isSelected: isSelected,
          onTap: () => setState(() => _selectedTime = time),
        );
      }).toList(),
    );
  }

  Widget _buildBottomAction() {
    final bool canContinue = _selectedSubject != null && _selectedTime != null;

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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: canContinue ? AppColors.primaryGradient : null,
            color: canContinue
                ? null
                : AppColors.textTertiary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
            boxShadow: canContinue
                ? [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    )
                  ]
                : null,
          ),
          child: ElevatedButton(
            onPressed:
                canContinue ? () => context.push(AppRoutes.checkout) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DourousiTheme.kBorderRadius)),
            ),
            child: Text(
              canContinue
                  ? AppStrings.continueToCheckout
                  : 'اختر المادة والوقت أولاً',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: canContinue ? Colors.white : AppColors.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Time Chip with bounce animation ──────────────────────────────────────────

class _TimeChip extends StatefulWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeChip({
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_TimeChip> createState() => _TimeChipState();
}

class _TimeChipState extends State<_TimeChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 220));
    _scale = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.08)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 40),
      TweenSequenceItem(
          tween: Tween(begin: 1.08, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 60),
    ]).animate(_ctrl);
  }

  @override
  void didUpdateWidget(_TimeChip old) {
    super.didUpdateWidget(old);
    if (!old.isSelected && widget.isSelected) {
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            gradient: widget.isSelected ? AppColors.primaryGradient : null,
            color: widget.isSelected ? null : AppColors.inputFill,
            borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
            border: Border.all(
              color: widget.isSelected
                  ? Colors.transparent
                  : AppColors.divider.withValues(alpha: 0.5),
            ),
          ),
          child: Text(
            widget.time,
            style: TextStyle(
              color: widget.isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
