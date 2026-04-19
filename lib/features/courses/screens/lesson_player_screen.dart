import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/app_theme.dart';
import '../../../models/app_models.dart';

class LessonPlayerScreen extends StatefulWidget {
  final String courseId;
  final String lessonId;
  const LessonPlayerScreen({super.key, required this.courseId, required this.lessonId});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  // Mocked lessons list
  final List<Lesson> _lessons = [
    Lesson(id: 'l1', title: 'مقدمة في قواعد اللغة', duration: '10:15', isLocked: false, videoUrl: 'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4'),
    Lesson(id: 'l2', title: 'الأزمنة في الإنجليزية', duration: '25:30', isLocked: false, videoUrl: 'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4'),
    Lesson(id: 'l3', title: 'تركيب الجمل الصحيحة', duration: '18:45', isLocked: false, videoUrl: 'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4'),
  ];

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final lesson = _lessons.firstWhere((l) => l.id == widget.lessonId, orElse: () => _lessons.first);
    
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(lesson.videoUrl));
    
    await _videoPlayerController.initialize();
    
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.primaryBlue,
        handleColor: AppColors.primaryBlue,
        backgroundColor: Colors.grey.withOpacity(0.2),
        bufferedColor: AppColors.primaryBlue.withOpacity(0.3),
      ),
      placeholder: Container(color: Colors.black),
      autoInitialize: true,
    );

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = _lessons.firstWhere((l) => l.id == widget.lessonId, orElse: () => _lessons.first);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Video Player Area
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  if (_isInitialized && _chewieController != null)
                    Chewie(controller: _chewieController!)
                  else
                    const Center(child: CircularProgressIndicator(color: AppColors.emeraldGreen)),
                  
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ],
              ),
            ),
            
            // 2. Info & Content Area
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "الوحدة الأولى • ${lesson.duration}",
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(AppStrings.lessonCompleted)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emeraldGreen,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("تحديد كمكتمل", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    
                    const SizedBox(height: 32),
                    const Text(
                      "قائمة الدروس",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _lessons.length,
                        itemBuilder: (context, index) {
                          final item = _lessons[index];
                          final isCurrent = item.id == widget.lessonId;
                          
                          return ListTile(
                            onTap: () {
                              if (!isCurrent) {
                                context.pushReplacement('/course/${widget.courseId}/lesson/${item.id}');
                              }
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isCurrent ? AppColors.primaryBlue : AppColors.inputFill,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    color: isCurrent ? Colors.white : AppColors.textSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                color: isCurrent ? AppColors.primaryBlue : AppColors.textPrimary,
                              ),
                            ),
                            subtitle: Text(item.duration, style: const TextStyle(fontSize: 11)),
                            trailing: isCurrent 
                              ? const Icon(Icons.equalizer_rounded, color: AppColors.primaryBlue)
                              : const Icon(Icons.play_circle_outline_rounded, size: 20, color: AppColors.textTertiary),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
