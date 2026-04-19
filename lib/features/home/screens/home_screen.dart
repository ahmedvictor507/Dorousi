import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../models/app_models.dart';
import '../../auth/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _categories = [
    AppStrings.all,
    AppStrings.kindergarten,
    AppStrings.primary,
    AppStrings.secondary,
  ];
  int _selectedCategoryIndex = 0;

  // Mock Data
  final List<LiveSession> _liveSessions = [
    LiveSession(
      id: '1',
      title: 'قوانين نيوتن وحل المسائل',
      teacherName: 'أ. نورا القحطاني',
      teacherImage: 'https://i.pravatar.cc/150?u=nora',
      subject: 'فيزياء - ثانوي',
      startTime: DateTime.now().add(const Duration(minutes: 30)),
      totalSeats: 50,
      availableSeats: 5,
      price: 0,
      zoomLink: 'https://zoom.us/j/123456789',
    ),
    LiveSession(
      id: '2',
      title: 'الجبر المتقدم والدوال',
      teacherName: 'أ. خالد العتيبي',
      teacherImage: 'https://i.pravatar.cc/150?u=khaled',
      subject: 'رياضيات',
      startTime: DateTime.now().add(const Duration(hours: 2)),
      totalSeats: 30,
      availableSeats: 12,
      price: 50,
      zoomLink: 'https://zoom.us/j/987654321',
    ),
  ];

  final List<Course> _courses = [
    Course(
      id: '1',
      title: 'دورة اللغة الإنجليزية الشاملة',
      subject: 'اللغات',
      teacherName: 'أ. مروان بناني',
      teacherImage: 'https://i.pravatar.cc/150?u=marwan',
      price: 150,
      imageUrl: 'https://images.unsplash.com/photo-1543165796-5426273ea4d1?q=80&w=500&auto=format&fit=crop',
    ),
    Course(
      id: '2',
      title: 'أساسيات البرمجة بلغة جافا',
      subject: 'علوم الحاسوب',
      teacherName: 'أ. ياسين الإدريسي',
      teacherImage: 'https://i.pravatar.cc/150?u=yassine',
      price: 200,
      imageUrl: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=500&auto=format&fit=crop',
    ),
  ];

  // Filtering logic
  List<LiveSession> get _filteredLiveSessions {
    if (_selectedCategoryIndex == 0) return _liveSessions;
    final category = _categories[_selectedCategoryIndex];
    return _liveSessions.where((s) => s.subject.contains(category)).toList();
  }

  List<Course> get _filteredCourses {
    if (_selectedCategoryIndex == 0) return _courses;
    final category = _categories[_selectedCategoryIndex];
    // Secondary mapping for better matching in mock data
    String mapping = category == AppStrings.secondary ? 'ثانوي' : category;
    return _courses.where((c) => c.subject.contains(mapping)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Premium App Bar
          _buildSliverAppBar(context, authProvider),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Animated Search Bar
                _buildSearchBar(context),

                // 3. Modern Category Tabs
                _buildCategoryTabs(context),

                const SizedBox(height: 20),

                // 4. Live Sessions Section
                SectionHeader(
                  title: AppStrings.liveClasses,
                  actionText: AppStrings.viewAll,
                  onActionTap: () {},
                ),
                _buildLiveSessionsList(),

                // 5. Registered Courses Section
                SectionHeader(
                  title: AppStrings.registeredCourses,
                  actionText: AppStrings.viewAll,
                  onActionTap: () {},
                ),
                _buildCoursesList(),

                const SizedBox(height: 30),

                // 6. Top Teachers
                _buildTopTeachersHeader(context),
                _buildTopTeachersList(context),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, AuthProvider authProvider) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlue.withOpacity(0.05),
                Theme.of(context).scaffoldBackgroundColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryLight,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=student'),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${AppStrings.hello} ${authProvider.userName}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                AppStrings.welcomeBack,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, size: 28),
              onPressed: () => context.push(AppRoutes.notifications),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Hero(
        tag: 'search_bar',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push(AppRoutes.search),
            borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light ? AppColors.inputFill : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
                border: Border.all(color: AppColors.divider.withOpacity(0.1)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search_rounded, color: AppColors.textTertiary),
                  SizedBox(width: 12),
                  Text(
                    AppStrings.searchHint,
                    style: TextStyle(color: AppColors.textTertiary, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategoryIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  color: isSelected ? null : (Theme.of(context).brightness == Brightness.light ? Colors.grey.shade200 : Colors.white.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected ? [BoxShadow(color: AppColors.primaryBlue.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))] : null,
                ),
                child: Center(
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLiveSessionsList() {
    if (_filteredLiveSessions.isEmpty) return _buildEmptyState();
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 20),
        itemCount: _filteredLiveSessions.length,
        itemBuilder: (context, index) {
          return LiveSessionCard(
            session: _filteredLiveSessions[index],
            onTap: () => context.push(AppRoutes.liveSessionDetailsPath(_filteredLiveSessions[index].id)),
          );
        },
      ),
    );
  }

  Widget _buildCoursesList() {
    if (_filteredCourses.isEmpty) return _buildEmptyState();
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 20),
        itemCount: _filteredCourses.length,
        itemBuilder: (context, index) {
          return CourseCard(
            course: _filteredCourses[index],
            onTap: () => context.push(AppRoutes.courseDetailsPath(_filteredCourses[index].id)),
          );
        },
      ),
    );
  }

  Widget _buildTopTeachersHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.verified_user_rounded, color: AppColors.primaryBlue, size: 20),
          const SizedBox(width: 8),
          Text(
            "أفضل المعلمين",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTeachersList(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 6,
        itemBuilder: (context, index) {
          final String teacherId = index % 2 == 0 ? 'marwan' : 'yassine';
          return Padding(
            padding: const EdgeInsets.only(left: 15),
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.teacherProfilePath(teacherId)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.emeraldGreen.withOpacity(0.2)),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=teacher_$index'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(index % 2 == 0 ? "أ. مروان" : "أ. ياسين", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 150,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? AppColors.inputFill : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: AppColors.textTertiary.withOpacity(0.5)),
          const SizedBox(height: 12),
          const Text(AppStrings.noResults, style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
