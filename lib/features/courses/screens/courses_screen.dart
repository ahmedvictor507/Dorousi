import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../models/app_models.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Enrolled Data
    final List<Course> enrolledCourses = [
      Course(
        id: '1',
        title: 'دورة اللغة الإنجليزية الشاملة',
        subject: 'اللغات',
        teacherName: 'أ. مروان بناني',
        teacherImage: 'https://i.pravatar.cc/150?u=marwan',
        price: 0,
        progress: 0.65, // 65% progress
        imageUrl:
            'https://images.unsplash.com/photo-1543165796-5426273ea4d1?q=80&w=500&auto=format&fit=crop',
        isEnrolled: true,
      ),
      Course(
        id: '10',
        title: 'قواعد اللغة العربية - باك حر',
        subject: 'اللغة العربية',
        teacherName: 'أ. فاطمة الزهراء',
        teacherImage: 'https://i.pravatar.cc/150?u=fatima',
        price: 0,
        progress: 0.2, // 20% progress
        imageUrl:
            'https://images.unsplash.com/photo-1516979187457-637abb4f9353?q=80&w=500&auto=format&fit=crop',
        isEnrolled: true,
      ),
    ];

    final List<LiveSession> scheduledSessions = [
      LiveSession(
        id: '1',
        title: 'قوانين نيوتن وحل المسائل',
        teacherName: 'أ. نورا القحطاني',
        teacherImage: 'https://i.pravatar.cc/150?u=nora',
        subject: 'فيزياء - ثانوي',
        startTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
        totalSeats: 50,
        availableSeats: 5,
        price: 0,
        isEnrolled: true,
        zoomLink: 'https://zoom.us/j/123456789',
      ),
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            AppStrings.myCourses,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.primaryBlue,
                unselectedLabelColor: AppColors.textTertiary,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: AppStrings.ongoingCourses),
                  Tab(text: AppStrings.scheduledSessions),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildOngoingTab(context, enrolledCourses),
                  _buildScheduledTab(context, scheduledSessions),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingTab(BuildContext context, List<Course> courses) {
    if (courses.isEmpty) {
      return _buildEmptyState(context, "ليس لديك دورات جارية حالياً");
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return CourseCard(
          course: courses[index],
          isHorizontal: false,
          onTap: () =>
              context.push(AppRoutes.courseDetailsPath(courses[index].id)),
        );
      },
    );
  }

  Widget _buildScheduledTab(BuildContext context, List<LiveSession> sessions) {
    if (sessions.isEmpty) {
      return _buildEmptyState(context, "لا توجد حصص مجدولة قريباً");
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        return LiveSessionCard(
          session: sessions[index],
          isHorizontal: false,
          onTap: () => context
              .push(AppRoutes.liveSessionDetailsPath(sessions[index].id)),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.menu_book_rounded,
                size: 60, color: AppColors.primaryBlue.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text("استكشف الدورات",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
