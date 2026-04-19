import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/app_models.dart';
import '../constants/app_colors.dart';
import '../app_theme.dart';
import 'dart:ui';
import 'package:intl/intl.dart' as intl;
import '../constants/app_strings.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.1,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? DourousiTheme.kCardRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: DourousiTheme.glassDecoration(opacity: opacity),
          child: child,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
          ),
          TextButton(
            onPressed: onActionTap,
            child: Row(
              children: [
                Text(
                  actionText,
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const Icon(Icons.chevron_right, size: 18, color: AppColors.primaryBlue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isHorizontal;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    this.isHorizontal = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isHorizontal ? 240 : double.infinity,
        margin: EdgeInsets.only(
          left: isHorizontal ? 15 : 0,
          bottom: isHorizontal ? 0 : 15,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: DourousiTheme.kCardRadius,
          boxShadow: DourousiTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(DourousiTheme.kBorderRadius),
                    topRight: Radius.circular(DourousiTheme.kBorderRadius),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: course.imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GlassContainer(
                    opacity: 0.6,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        course.subject,
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(course.teacherImage),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        course.teacherName,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (course.isEnrolled) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: course.progress,
                              backgroundColor: AppColors.inputFill,
                              color: AppColors.emeraldGreen,
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${(course.progress * 100).toInt()}%',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.emeraldGreen),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${course.price.toStringAsFixed(0)} ${AppStrings.currency}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryBlue,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.add_shopping_cart, size: 18, color: AppColors.primaryBlue),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveSessionCard extends StatelessWidget {
  final LiveSession session;
  final bool isHorizontal;
  final VoidCallback onTap;

  const LiveSessionCard({
    super.key,
    required this.session,
    this.isHorizontal = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isHorizontal ? 280 : double.infinity,
        margin: EdgeInsets.only(
          left: isHorizontal ? 15 : 0,
          bottom: isHorizontal ? 0 : 15,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).cardColor,
              Theme.of(context).cardColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: DourousiTheme.kCardRadius,
          boxShadow: DourousiTheme.softShadow,
          border: Border.all(color: AppColors.divider.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(session.teacherImage),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.teacherName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        session.subject,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (session.isActive)
                  GlassContainer(
                    opacity: 0.1,
                    blur: 5,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.liveBadgeBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.fiber_manual_record, size: 8, color: AppColors.liveBadge),
                          const SizedBox(width: 4),
                          const Text(
                            AppStrings.live,
                            style: TextStyle(color: AppColors.liveBadge, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              session.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoTag(context, Icons.access_time_rounded, intl.DateFormat('hh:mm a').format(session.startTime)),
                const SizedBox(width: 12),
                _buildInfoTag(context, Icons.people_outline_rounded, "${session.availableSeats} ${AppStrings.seats}"),
              ],
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.emeraldGreen.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  AppStrings.joinNow,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTag(BuildContext context, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textTertiary),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
