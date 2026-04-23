import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../widgets/main_shell.dart';

import '../../features/splash/screens/splash_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/verify_code_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/courses/screens/courses_screen.dart';
import '../../features/courses/screens/course_details_screen.dart';
import '../../features/courses/screens/lesson_player_screen.dart';
import '../../features/live_sessions/screens/live_session_details_screen.dart';
import '../../features/messages/screens/messages_screen.dart';
import '../../features/messages/screens/chat_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/app_settings_screen.dart';
import '../../features/teachers/screens/teacher_profile_screen.dart';
import '../../features/booking/screens/booking_screen.dart';
import '../../features/bookings/screens/my_bookings_screen.dart';
import '../../features/checkout/screens/checkout_screen.dart';
import '../../features/checkout/screens/payment_success_screen.dart';
import '../../features/checkout/screens/payment_gate_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/auth/providers/auth_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _coursesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'courses');
final _messagesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'messages');
final _profileNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'profile');

class AppRouter {
  AppRouter._();

  static GoRouter router(AuthProvider authProvider) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final currentPath = state.uri.path;

        final authPaths = [
          AppRoutes.splash,
          AppRoutes.onboarding,
          AppRoutes.login,
          AppRoutes.signup,
          AppRoutes.forgotPassword,
          AppRoutes.verifyCode,
          AppRoutes.resetPassword,
        ];

        final isOnAuthRoute = authPaths.contains(currentPath);
        if (currentPath == AppRoutes.splash) return null;
        if (!isLoggedIn && !isOnAuthRoute) return AppRoutes.login;
        if (isLoggedIn && isOnAuthRoute) return AppRoutes.home;
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),

        // ── Auth ──
        GoRoute(
            path: AppRoutes.login,
            builder: (_, __) => const LoginScreen()),
        GoRoute(
            path: AppRoutes.signup,
            builder: (_, __) => const SignupScreen()),
        GoRoute(
            path: AppRoutes.forgotPassword,
            builder: (_, __) => const ForgotPasswordScreen()),
        GoRoute(
            path: AppRoutes.verifyCode,
            builder: (_, __) => const VerifyCodeScreen()),
        GoRoute(
            path: AppRoutes.resetPassword,
            builder: (_, __) => const ResetPasswordScreen()),

        // ── Main Shell ──
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              MainShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              navigatorKey: _homeNavigatorKey,
              routes: [
                GoRoute(
                    path: AppRoutes.home,
                    builder: (_, __) => const HomeScreen()),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _coursesNavigatorKey,
              routes: [
                GoRoute(
                    path: AppRoutes.courses,
                    builder: (_, __) => const CoursesScreen()),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _messagesNavigatorKey,
              routes: [
                GoRoute(
                  path: AppRoutes.messages,
                  builder: (_, __) => const MessagesScreen(),
                  routes: [
                    GoRoute(
                      path: 'chat/:conversationId',
                      builder: (context, state) => ChatScreen(
                        conversationId:
                            state.pathParameters['conversationId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _profileNavigatorKey,
              routes: [
                GoRoute(
                    path: AppRoutes.profile,
                    builder: (_, __) => const ProfileScreen()),
              ],
            ),
          ],
        ),

        // ── Detail screens ──
        GoRoute(
          path: '/course/:courseId',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => CourseDetailsScreen(
            courseId: state.pathParameters['courseId']!,
          ),
          routes: [
            GoRoute(
              path: 'lesson/:lessonId',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => LessonPlayerScreen(
                courseId: state.pathParameters['courseId']!,
                lessonId: state.pathParameters['lessonId']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/live-session/:sessionId',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => LiveSessionDetailsScreen(
            sessionId: state.pathParameters['sessionId']!,
          ),
        ),
        GoRoute(
          path: '/teacher/:teacherId',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => TeacherProfileScreen(
            teacherId: state.pathParameters['teacherId']!,
          ),
          routes: [
            GoRoute(
              path: 'book',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => BookingScreen(
                teacherId: state.pathParameters['teacherId']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.checkout,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __) => const CheckoutScreen(),
        ),
        GoRoute(
          path: AppRoutes.paymentSuccess,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __) => const PaymentSuccessScreen(),
        ),
        GoRoute(
          path: AppRoutes.paymentGate,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __) => const PaymentGateScreen(),
        ),
        GoRoute(
          path: AppRoutes.search,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __) => const SearchScreen(),
        ),
        GoRoute(
          path: AppRoutes.notifications,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __) => const NotificationsScreen(),
        ),
        GoRoute(
          path: AppRoutes.editProfile,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __) => const EditProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.appSettings,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __) => const AppSettingsScreen(),
        ),

        // ── New routes ──
        GoRoute(
          path: AppRoutes.myBookings,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (_, __) => const MyBookingsScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('الصفحة غير موجودة',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(state.uri.toString(),
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
