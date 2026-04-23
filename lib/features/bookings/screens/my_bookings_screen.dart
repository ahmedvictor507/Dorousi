import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';

enum _BookingStatus { upcoming, completed, cancelled }

class _Booking {
  final String id;
  final String teacherName;
  final String teacherImage;
  final String subject;
  final DateTime dateTime;
  final _BookingStatus status;
  final double price;

  const _Booking({
    required this.id,
    required this.teacherName,
    required this.teacherImage,
    required this.subject,
    required this.dateTime,
    required this.status,
    required this.price,
  });
}

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  final _bookings = [
    _Booking(
      id: '1',
      teacherName: 'أ. ياسين الإدريسي',
      teacherImage: 'https://i.pravatar.cc/150?u=yassine',
      subject: 'علوم حاسوب',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 4)),
      status: _BookingStatus.upcoming,
      price: 150,
    ),
    _Booking(
      id: '2',
      teacherName: 'أ. نورا القحطاني',
      teacherImage: 'https://i.pravatar.cc/150?u=nora',
      subject: 'فيزياء',
      dateTime: DateTime.now().add(const Duration(days: 5, hours: 6)),
      status: _BookingStatus.upcoming,
      price: 120,
    ),
    _Booking(
      id: '3',
      teacherName: 'أ. مروان بناني',
      teacherImage: 'https://i.pravatar.cc/150?u=marwan',
      subject: 'اللغة الإنجليزية',
      dateTime: DateTime.now().subtract(const Duration(days: 3)),
      status: _BookingStatus.completed,
      price: 100,
    ),
    _Booking(
      id: '4',
      teacherName: 'أ. خالد العتيبي',
      teacherImage: 'https://i.pravatar.cc/150?u=khaled',
      subject: 'رياضيات',
      dateTime: DateTime.now().subtract(const Duration(days: 7)),
      status: _BookingStatus.cancelled,
      price: 130,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<_Booking> _filtered(_BookingStatus status) =>
      _bookings.where((b) => b.status == status).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            floating: false,
            backgroundColor: AppColors.primaryBlue,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 18),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding:
                  const EdgeInsets.only(left: 64, right: 16, bottom: 16),
              title: const Text('حجوزاتي',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17)),
              background: Container(
                decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient),
                child: const Align(
                  alignment: Alignment(-0.9, -0.3),
                  child: Opacity(
                    opacity: 0.08,
                    child: Icon(Icons.calendar_month_rounded,
                        size: 180, color: Colors.white),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: AppColors.primaryBlue,
                child: TabBar(
                  controller: _tabCtrl,
                  indicatorColor: AppColors.emeraldGreen,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                  tabs: const [
                    Tab(text: 'القادمة'),
                    Tab(text: 'المنتهية'),
                    Tab(text: 'الملغاة'),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _BookingList(
                    bookings: _filtered(_BookingStatus.upcoming),
                    status: _BookingStatus.upcoming),
                _BookingList(
                    bookings: _filtered(_BookingStatus.completed),
                    status: _BookingStatus.completed),
                _BookingList(
                    bookings: _filtered(_BookingStatus.cancelled),
                    status: _BookingStatus.cancelled),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<_Booking> bookings;
  final _BookingStatus status;

  const _BookingList({required this.bookings, required this.status});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_rounded,
                size: 60, color: AppColors.textTertiary.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            const Text('لا توجد حجوزات',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return StaggeredEntrance(
          index: index,
          child: _BookingCard(booking: bookings[index]),
        );
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  final _Booking booking;

  const _BookingCard({required this.booking});

  Color get _statusColor {
    switch (booking.status) {
      case _BookingStatus.upcoming:
        return AppColors.primaryBlue;
      case _BookingStatus.completed:
        return AppColors.emeraldGreen;
      case _BookingStatus.cancelled:
        return AppColors.error;
    }
  }

  String get _statusLabel {
    switch (booking.status) {
      case _BookingStatus.upcoming:
        return 'مؤكدة';
      case _BookingStatus.completed:
        return 'منتهية';
      case _BookingStatus.cancelled:
        return 'ملغاة';
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = booking.dateTime.day.toString().padLeft(2, '0');
    final month = _monthAr(booking.dateTime.month);
    final hour = booking.dateTime.hour.toString().padLeft(2, '0');
    final min = booking.dateTime.minute.toString().padLeft(2, '0');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
        boxShadow: DourousiTheme.softShadow,
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Status bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: _statusColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(DourousiTheme.kBorderRadius),
                topRight: Radius.circular(DourousiTheme.kBorderRadius),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage:
                          NetworkImage(booking.teacherImage),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(booking.teacherName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text(booking.subject,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(_statusLabel,
                          style: TextStyle(
                              color: _statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _infoItem(Icons.calendar_today_rounded,
                          '$day $month'),
                      _divider(),
                      _infoItem(Icons.access_time_rounded, '$hour:$min'),
                      _divider(),
                      _infoItem(Icons.payments_rounded,
                          '${booking.price.toStringAsFixed(0)} د.م.'),
                    ],
                  ),
                ),
                if (booking.status == _BookingStatus.upcoming) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('إلغاء'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('إضافة للتقويم',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (booking.status == _BookingStatus.completed) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.star_border_rounded, size: 18),
                      label: const Text('تقييم الحصة'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryBlue,
                        side: const BorderSide(
                            color: AppColors.primaryBlue),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primaryBlue),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _divider() {
    return Container(
        height: 20,
        width: 1,
        color: AppColors.divider.withValues(alpha: 0.5));
  }

  String _monthAr(int m) {
    const months = [
      '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return months[m];
  }
}
