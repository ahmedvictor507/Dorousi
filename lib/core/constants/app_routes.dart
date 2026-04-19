/// Centralized route path constants for the Dourousi app.
/// Used by go_router and for navigation references throughout the codebase.
class AppRoutes {
  AppRoutes._();

  // ─── Root / Splash ───────────────────────────────────────────────
  static const String splash = '/';

  // ─── Auth ────────────────────────────────────────────────────────
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String verifyCode = '/verify-code';
  static const String resetPassword = '/reset-password';

  // ─── Main Shell (Bottom Nav) ─────────────────────────────────────
  static const String home = '/home';
  static const String courses = '/courses';
  static const String messages = '/messages';
  static const String profile = '/profile';

  // ─── Search ──────────────────────────────────────────────────────
  static const String search = '/search';

  // ─── Notifications ──────────────────────────────────────────────
  static const String notifications = '/notifications';

  // ─── Course Details ──────────────────────────────────────────────
  static const String courseDetails = '/course/:courseId';
  static const String lessonPlayer = '/course/:courseId/lesson/:lessonId';

  // ─── Live Sessions ───────────────────────────────────────────────
  static const String liveSessionDetails = '/live-session/:sessionId';

  // ─── Teacher ─────────────────────────────────────────────────────
  static const String teacherProfile = '/teacher/:teacherId';

  // ─── Booking ─────────────────────────────────────────────────────
  static const String booking = '/teacher/:teacherId/book';

  // ─── Checkout ────────────────────────────────────────────────────
  static const String checkout = '/checkout';
  static const String paymentSuccess = '/payment-success';

  // ─── Profile Sub-routes ──────────────────────────────────────────
  static const String editProfile = '/profile/edit';
  static const String appSettings = '/profile/settings';

  // ─── Helper to build parameterized routes ────────────────────────
  static String courseDetailsPath(String courseId) => '/course/$courseId';
  static String lessonPlayerPath(String courseId, String lessonId) =>
      '/course/$courseId/lesson/$lessonId';
  static String liveSessionDetailsPath(String sessionId) =>
      '/live-session/$sessionId';
  static String teacherProfilePath(String teacherId) => '/teacher/$teacherId';
  static String bookingPath(String teacherId) => '/teacher/$teacherId/book';
}
