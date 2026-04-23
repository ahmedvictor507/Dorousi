import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isRead;
  final String? route;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isRead = false,
    this.route,
  });
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NotificationItem> notifications = [
      NotificationItem(
        id: '1',
        title: 'تبدأ حصة الفيزياء الآن!',
        body: 'أ. نورا القحطاني بانتظارك في حصة قوانين نيوتن المباشرة.',
        time: 'الآن',
        icon: Icons.live_tv_rounded,
        iconColor: AppColors.liveBadge,
        route: AppRoutes.liveSessionDetailsPath('1'),
      ),
      NotificationItem(
        id: '2',
        title: 'رسالة جديدة',
        body: 'لقد أرسل لك أ. مروان بناني رسالة جديدة بخصوص الواجب.',
        time: 'قبل 15 دقيقة',
        icon: Icons.chat_bubble_outline_rounded,
        iconColor: AppColors.primaryBlue,
        route: AppRoutes.messages,
      ),
      NotificationItem(
        id: '3',
        title: 'تم فتح الدورة بنجاح',
        body: 'مبروك! يمكنك الآن البدء في مشاهدة دروس دورة اللغة الإنجليزية.',
        time: 'قبل ساعتين',
        icon: Icons.lock_open_rounded,
        iconColor: AppColors.emeraldGreen,
        isRead: true,
        route: AppRoutes.courseDetailsPath('1'),
      ),
      NotificationItem(
        id: '4',
        title: 'تذكير بالموعد',
        body: 'لديك حصة خاصة غداً مع أ. ياسين الإدريسي في تمام الساعة 4 مساءً.',
        time: 'قبل يوم',
        icon: Icons.event_rounded,
        iconColor: AppColors.warning,
        isRead: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notifications),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return ListTile(
                  onTap: () {
                    if (item.route != null) {
                      context.push(item.route!);
                    }
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  tileColor: item.isRead
                      ? Colors.transparent
                      : AppColors.primaryBlue.withOpacity(0.03),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: item.iconColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, color: item.iconColor, size: 24),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontWeight:
                                item.isRead ? FontWeight.w600 : FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        item.time,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      item.body,
                      style: TextStyle(
                        fontSize: 13,
                        color: item.isRead
                            ? AppColors.textSecondary
                            : AppColors.textPrimary.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_rounded,
              size: 80, color: AppColors.textTertiary.withOpacity(0.2)),
          const SizedBox(height: 20),
          const Text(
            AppStrings.noNotifications,
            style: TextStyle(fontSize: 18, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
