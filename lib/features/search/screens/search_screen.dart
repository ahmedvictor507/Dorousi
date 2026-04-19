import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../models/app_models.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _query = "";
  int _selectedFilterIndex = 0; // 0: All, 1: Courses, 2: Teachers

  final List<String> _filters = [AppStrings.all, 'الدورات', 'المعلمون'];

  // Mock Data
  final List<Course> _allCourses = [
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
    Course(
      id: '3',
      title: 'التحليل الرياضي والميكانيك',
      subject: 'رياضيات - ثانوي',
      teacherName: 'أ. خديجة',
      teacherImage: 'https://i.pravatar.cc/150?u=khadija',
      price: 180,
      imageUrl: 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?q=80&w=500&auto=format&fit=crop',
    ),
  ];

  final List<Teacher> _allTeachers = [
    Teacher(id: 't1', name: 'أ. مروان بناني', subject: 'لغات', imageUrl: 'https://i.pravatar.cc/150?u=marwan', bio: 'خبير في تدريس الإنجليزية'),
    Teacher(id: 't2', name: 'أ. ياسين الإدريسي', subject: 'علوم حاسوب', imageUrl: 'https://i.pravatar.cc/150?u=yassine', bio: 'مطور برمجيات ومعلم'),
    Teacher(id: 't3', name: 'أ. خديجة الصقلي', subject: 'رياضيات', imageUrl: 'https://i.pravatar.cc/150?u=khadija', bio: 'معلمة متميزة في الفيزياء والرياضيات'),
  ];

  List<dynamic> get _searchResults {
    if (_query.isEmpty) return [];

    List<dynamic> results = [];
    
    if (_selectedFilterIndex == 0 || _selectedFilterIndex == 1) {
      results.addAll(_allCourses.where((c) => 
        c.title.contains(_query) || c.subject.contains(_query) || c.teacherName.contains(_query)
      ));
    }
    
    if (_selectedFilterIndex == 0 || _selectedFilterIndex == 2) {
      results.addAll(_allTeachers.where((t) => 
        t.name.contains(_query) || t.subject.contains(_query)
      ));
    }

    return results;
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Hero(
          tag: 'search_bar',
          child: Material(
            color: Colors.transparent,
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: (val) => setState(() => _query = val),
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light ? AppColors.inputFill : Colors.white.withOpacity(0.05),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textTertiary),
                suffixIcon: _query.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = "");
                      },
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          // Filter Chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: FilterChip(
                    label: Text(_filters[index]),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedFilterIndex = index),
                    showCheckmark: false,
                    selectedColor: AppColors.primaryBlue,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _query.isEmpty 
              ? _buildRecentSearches()
              : _searchResults.isEmpty 
                  ? _buildNoResults()
                  : _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "عمليات البحث الأخيرة",
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 15),
          _buildRecentItem("دروس الرياضيات"),
          _buildRecentItem("الإنجليزية للمبتدئين"),
          _buildRecentItem("أستاذ مروان"),
        ],
      ),
    );
  }

  Widget _buildRecentItem(String text) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.history_rounded, color: AppColors.textTertiary, size: 20),
      title: Text(text, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
      trailing: const Icon(Icons.north_west_rounded, size: 16, color: AppColors.textTertiary),
      onTap: () {
        _searchController.text = text;
        setState(() => _query = text);
      },
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: AppColors.textTertiary.withOpacity(0.3)),
          const SizedBox(height: 20),
          const Text(AppStrings.noResults, style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    final results = _searchResults;
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        if (item is Course) {
          return CourseCard(
            course: item,
            isHorizontal: false,
            onTap: () => context.push(AppRoutes.courseDetailsPath(item.id)),
          );
        } else if (item is Teacher) {
          return _buildTeacherTile(item);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTeacherTile(Teacher teacher) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: DourousiTheme.kCardRadius,
        boxShadow: DourousiTheme.softShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(teacher.imageUrl),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(teacher.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(teacher.subject, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primaryBlue),
            onPressed: () => context.push(AppRoutes.teacherProfilePath(teacher.id)),
          ),
        ],
      ),
    );
  }
}
