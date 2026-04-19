import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/app_theme.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionTitle("العامة"),
          _buildSettingTile(
            context,
            "إشعارات النظام",
            "استلام تنبيهات بخصوص الحصص الجديدة",
            Icons.notifications_active_outlined,
            trailing: Switch(value: true, onChanged: (v) {}, activeThumbColor: AppColors.emeraldGreen),
          ),
          _buildSettingTile(
            context,
            "الوضع الليلي",
            "تحويل مظهر التطبيق للوضع الداكن",
            Icons.dark_mode_outlined,
            trailing: Switch(value: false, onChanged: (v) {}, activeThumbColor: AppColors.emeraldGreen),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle("الخصوصية والأمان"),
          _buildSettingTile(context, "تغيير كلمة المرور", null, Icons.lock_outline_rounded, onTap: () {}),
          _buildSettingTile(context, "سياسة الخصوصية", null, Icons.privacy_tip_outlined, onTap: () {}),
          _buildSettingTile(context, "شروط الاستخدام", null, Icons.description_outlined, onTap: () {}),
          const SizedBox(height: 32),
          _buildSectionTitle("عن التطبيق"),
          _buildSettingTile(context, "الإصدار", "1.0.0 (بناء 102)", Icons.info_outline_rounded),
          const SizedBox(height: 48),
          _buildDangerZone(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, String title, String? subtitle, IconData icon, {Widget? trailing, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.primaryBlue.withOpacity(0.05), shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.primaryBlue, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
        trailing: trailing ?? (onTap != null ? const Icon(Icons.arrow_forward_ios_rounded, size: 14) : null),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("منطقة الخطر", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.error)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.error.withOpacity(0.2)),
          ),
          child: ListTile(
            onTap: () {},
            leading: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
            title: const Text("حذف الحساب", style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
            subtitle: const Text("سيتم حذف جميع بياناتك نهائياً", style: TextStyle(fontSize: 12, color: AppColors.error)),
          ),
        ),
      ],
    );
  }
}
