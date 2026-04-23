import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../models/app_models.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String courseId;
  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock Data for the specific course
  late Course _course;
  bool _isEnrolled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Simulate fetching course data
    _course = Course(
      id: widget.courseId,
      title: 'دورة اللغة الإنجليزية الشاملة',
      subject: 'اللغات',
      teacherName: 'أ. مروان بناني',
      teacherImage: 'https://i.pravatar.cc/150?u=marwan',
      price: 150,
      imageUrl:
          'https://images.unsplash.com/photo-1543165796-5426273ea4d1?q=80&w=1200&auto=format&fit=crop',
      lessons: [
        Lesson(
            id: 'l1',
            title: 'مقدمة في قواعد اللغة',
            duration: '10:15',
            isLocked: false,
            videoUrl:
                'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4'),
        Lesson(
            id: 'l2',
            title: 'الأزمنة في الإنجليزية',
            duration: '25:30',
            isLocked: true,
            videoUrl:
                'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4'),
        Lesson(
            id: 'l3',
            title: 'تركيب الجمل الصحيحة',
            duration: '18:45',
            isLocked: true,
            videoUrl:
                'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4'),
        Lesson(
            id: 'l4',
            title: 'المحادثة اليومية',
            duration: '30:00',
            isLocked: true,
            videoUrl:
                'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4'),
      ],
    );

    // If ID is '1', assume enrolled for demo purposes if coming from a success redirect later
    if (widget.courseId == '1_enrolled') {
      _isEnrolled = true;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeader(),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCourseInfo(),
                      const SizedBox(height: 24),
                      _buildTabs(),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 400, // Fixed height for tab view in sliver
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildOverview(),
                            _buildCurriculum(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100), // Space for sticky button
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!_isEnrolled) _buildStickyBuyButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.3),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: _course.imageUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black26, Colors.black54],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _course.subject,
                style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
            const Spacer(),
            const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            const Text("4.9 (240 تقييم)",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          _course.title,
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => context.push(AppRoutes.teacherProfilePath('t1')),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(_course.teacherImage),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_course.teacherName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text("معلم لغات معتمد",
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
              const Spacer(),
              const Text(
                "عرض الملف",
                style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: "نظرة عامة"),
          Tab(text: "المنهج الدراسي"),
        ],
      ),
    );
  }

  Widget _buildOverview() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "عن هذه الدورة",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            "هذه الدورة مصممة لمساعدتك على إتقان اللغة الإنجليزية من الصفر حتى الاحتراف. ستتعلم القواعد الأساسية، كيفية تكوين الجمل، وطرق المحادثة اليومية بأسلوب مبسط وممتع.",
            style: TextStyle(height: 1.6, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFeatureItem(Icons.play_circle_outline, "12 درس"),
              _buildFeatureItem(Icons.access_time, "8 ساعات"),
              _buildFeatureItem(Icons.article_outlined, "ملفات PDF"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryBlue),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildCurriculum() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _course.lessons.length,
      itemBuilder: (context, index) {
        final lesson = _course.lessons[index];
        final bool canPlay = _isEnrolled || !lesson.isLocked;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider.withOpacity(0.3)),
          ),
          child: ListTile(
            onTap: () {
              if (canPlay) {
                context.push('/course/${widget.courseId}/lesson/${lesson.id}');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("يرجى شراء الدورة للوصول لهذا الدرس")),
                );
              }
            },
            leading: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: canPlay
                        ? AppColors.primaryBlue.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    canPlay
                        ? Icons.play_arrow_rounded
                        : Icons.lock_outline_rounded,
                    color: canPlay
                        ? AppColors.primaryBlue
                        : AppColors.textTertiary,
                  ),
                ),
                if (lesson.isCompleted)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.check_circle,
                          color: AppColors.emeraldGreen, size: 16),
                    ),
                  ),
              ],
            ),
            title: Text(
              lesson.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: canPlay ? AppColors.textPrimary : AppColors.textTertiary,
              ),
            ),
            subtitle:
                Text(lesson.duration, style: const TextStyle(fontSize: 12)),
          ),
        );
      },
    );
  }

  Widget _buildStickyBuyButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("السعر الإجمالي",
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                  Text(
                    "${_course.price.toStringAsFixed(0)} ${AppStrings.currency}",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    onPressed: () => context.push(AppRoutes.paymentGate),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      AppStrings.buyCourse,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
