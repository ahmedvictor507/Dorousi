class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';

  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String verifyCode = '/verify-code';
  static const String resetPassword = '/reset-password';

  static const String home = '/home';
  static const String courses = '/courses';
  static const String messages = '/messages';
  static const String profile = '/profile';

  static const String search = '/search';
  static const String notifications = '/notifications';

  static const String courseDetails = '/course/:courseId';
  static const String lessonPlayer = '/course/:courseId/lesson/:lessonId';
  static const String liveSessionDetails = '/live-session/:sessionId';
  static const String teacherProfile = '/teacher/:teacherId';
  static const String booking = '/teacher/:teacherId/book';
  static const String checkout = '/checkout';
  static const String paymentSuccess = '/payment-success';
  static const String paymentGate = '/payment-gate';

  static const String editProfile = '/profile/edit';
  static const String appSettings = '/profile/settings';

  // ── New routes ─────────────────────────────────────────────────
  static const String myBookings = '/my-bookings';

  static String courseDetailsPath(String courseId) => '/course/$courseId';
  static String lessonPlayerPath(String courseId, String lessonId) =>
      '/course/$courseId/lesson/$lessonId';
  static String liveSessionDetailsPath(String sessionId) =>
      '/live-session/$sessionId';
  static String teacherProfilePath(String teacherId) =>
      '/teacher/$teacherId';
  static String bookingPath(String teacherId) =>
      '/teacher/$teacherId/book';
}
