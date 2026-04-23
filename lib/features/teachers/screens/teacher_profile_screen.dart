import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../models/app_models.dart';

class TeacherProfileScreen extends StatelessWidget {
  final String teacherId;
  const TeacherProfileScreen({super.key, required this.teacherId});

  @override
  Widget build(BuildContext context) {
    // Mock Data for the teacher
    final Teacher teacher = Teacher(
      id: teacherId,
      name: 'أ. ياسين الإدريسي',
      subject: 'خبير علوم الحاسوب والبرمجة',
      imageUrl: 'https://i.pravatar.cc/150?u=yassine',
      bio:
          'أستاذ متخصص في علوم الحاسوب والبرمجة مع خبرة تزيد عن 10 سنوات في تدريس تقنيات الويب وتطبيقات الجوال. هدفي هو تبسيط المفاهيم المعقدة وجعل البرمجة ممتعة للجميع.',
      rating: 4.8,
      studentsCount: 3500,
      coursesCount: 12,
    );

    final List<Course> teacherCourses = [
      Course(
        id: '2',
        title: 'أساسيات البرمجة بلغة جافا',
        subject: 'علوم الحاسوب',
        teacherName: teacher.name,
        teacherImage: teacher.imageUrl,
        price: 200,
        imageUrl:
            'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=500&auto=format&fit=crop',
      ),
      Course(
        id: '3',
        title: 'تطوير تطبيقات الويب الحديثة',
        subject: 'تطوير الويب',
        teacherName: teacher.name,
        teacherImage: teacher.imageUrl,
        price: 250,
        imageUrl:
            'https://images.unsplash.com/photo-1498050108023-c5249f4df085?q=80&w=500&auto=format&fit=crop',
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, teacher),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context, teacher),
                _buildStats(context, teacher),
                _buildBio(context, teacher),
                _buildAvailableCourses(context, teacherCourses),
                _buildActionButtons(context, teacher),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Teacher teacher) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primaryBlue,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 20),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
            ),
            const Center(
              child: Opacity(
                opacity: 0.1,
                child:
                    Icon(Icons.school_rounded, size: 150, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Teacher teacher) {
    return Transform.translate(
      offset: const Offset(0, -50),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(teacher.imageUrl),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              teacher.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              teacher.subject,
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context, Teacher teacher) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: DourousiTheme.softShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(context, teacher.rating.toString(), "التقييم",
                Icons.star_rounded, Colors.amber),
            _buildStatItem(context, teacher.studentsCount.toString(), "طالب",
                Icons.people_rounded, AppColors.emeraldGreen),
            _buildStatItem(context, teacher.coursesCount.toString(), "دورة",
                Icons.play_lesson_rounded, AppColors.primaryBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label,
      IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildBio(BuildContext context, Teacher teacher) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(AppStrings.bio,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            teacher.bio,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textSecondary, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableCourses(BuildContext context, List<Course> courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.availableCourses,
          actionText: AppStrings.viewAll,
          onActionTap: () {},
        ),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 20),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return CourseCard(
                course: courses[index],
                onTap: () => context
                    .push(AppRoutes.courseDetailsPath(courses[index].id)),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Teacher teacher) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ElevatedButton(
              onPressed: () => context.push('/teacher/${teacher.id}/book'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                AppStrings.bookPrivate,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.push(AppRoutes.messages),
            child: const Text("مراسلة المعلم"),
          ),
        ],
      ),
    );
  }
}
