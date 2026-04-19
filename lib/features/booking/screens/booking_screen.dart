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

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTime;
  String? _selectedSubject;

  final List<String> _subjects = ['رياضيات', 'فيزياء', 'علوم حاسوب'];
  final List<String> _timeSlots = ['04:00 PM', '05:00 PM', '06:00 PM', '07:00 PM', '08:00 PM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bookPrivate),
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
            _buildTeacherSummary(),
            const SizedBox(height: 32),
            _buildSectionTitle(AppStrings.selectSubject),
            const SizedBox(height: 12),
            _buildSubjectPicker(),
            const SizedBox(height: 32),
            _buildSectionTitle(AppStrings.selectDate),
            const SizedBox(height: 12),
            _buildDateCalendar(),
            const SizedBox(height: 32),
            _buildSectionTitle(AppStrings.selectTime),
            const SizedBox(height: 12),
            _buildTimePicker(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: _buildBottomAction(),
    );
  }

  Widget _buildTeacherSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=yassine'),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('أ. ياسين الإدريسي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('خبير علوم الحاسوب', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    );
  }

  Widget _buildSubjectPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSubject,
          hint: const Text(AppStrings.selectSubject, style: TextStyle(fontSize: 14)),
          isExpanded: true,
          items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (val) => setState(() => _selectedSubject = val),
        ),
      ),
    );
  }

  Widget _buildDateCalendar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: DourousiTheme.softShadow,
      ),
      child: CalendarDatePicker(
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 90)),
        onDateChanged: (date) => setState(() => _selectedDate = date),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _timeSlots.map((time) {
        final isSelected = _selectedTime == time;
        return InkWell(
          onTap: () => setState(() => _selectedTime = time),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryBlue : AppColors.inputFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? AppColors.primaryBlue : Colors.transparent),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomAction() {
    final bool canContinue = _selectedSubject != null && _selectedTime != null;

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
            gradient: canContinue ? AppColors.primaryGradient : null,
            color: canContinue ? null : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ElevatedButton(
            onPressed: canContinue ? () => context.push(AppRoutes.checkout) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
            ),
            child: const Text(
              AppStrings.continueToCheckout,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
