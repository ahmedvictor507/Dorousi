import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/app_routes.dart';
import '../widgets/main_shell.dart';

// ─── Feature Screens ─────────────────────────────────────────────────────
import '../../features/splash/screens/splash_screen.dart';
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
import '../../features/checkout/screens/checkout_screen.dart';
import '../../features/checkout/screens/payment_success_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/auth/providers/auth_provider.dart';

/// Global navigator keys for the shell branches
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _coursesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'courses');
final _messagesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'messages');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

/// App Router Configuration
///
/// Route structure mirrors the Master User Flow:
/// 1. Splash → checks connectivity + auth state
/// 2. Auth routes (login, signup, forgot password flow)
/// 3. Main shell with bottom nav (home, courses, messages, profile)
/// 4. Detail screens pushed on top of the shell
class AppRouter {
  AppRouter._();

  static GoRouter router(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,

      // ─── Redirect Logic ──────────────────────────────────────────
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final currentPath = state.uri.path;

        // Auth routes that don't require login
        final authPaths = [
          AppRoutes.splash,
          AppRoutes.login,
          AppRoutes.signup,
          AppRoutes.forgotPassword,
          AppRoutes.verifyCode,
          AppRoutes.resetPassword,
        ];

        final isOnAuthRoute = authPaths.contains(currentPath);

        // If on splash, don't redirect — splash handles its own navigation
        if (currentPath == AppRoutes.splash) return null;

        // If not logged in and trying to access a protected route
        if (!isLoggedIn && !isOnAuthRoute) return AppRoutes.login;

        // If logged in and trying to access auth routes
        if (isLoggedIn && isOnAuthRoute) return AppRoutes.home;

        return null;
      },

      // ─── Routes ──────────────────────────────────────────────────
      routes: [
        // Splash Screen
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),

        // ─── Auth Flow ─────────────────────────────────────────────
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.signup,
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: AppRoutes.verifyCode,
          builder: (context, state) => const VerifyCodeScreen(),
        ),
        GoRoute(
          path: AppRoutes.resetPassword,
          builder: (context, state) => const ResetPasswordScreen(),
        ),

        // ─── Main Shell with Bottom Navigation ─────────────────────
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainShell(navigationShell: navigationShell);
          },
          branches: [
            // Tab 0: Home
            StatefulShellBranch(
              navigatorKey: _homeNavigatorKey,
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),

            // Tab 1: My Courses (دوراتي)
            StatefulShellBranch(
              navigatorKey: _coursesNavigatorKey,
              routes: [
                GoRoute(
                  path: AppRoutes.courses,
                  builder: (context, state) => const CoursesScreen(),
                ),
              ],
            ),

            // Tab 2: Messages
            StatefulShellBranch(
              navigatorKey: _messagesNavigatorKey,
              routes: [
                GoRoute(
                  path: AppRoutes.messages,
                  builder: (context, state) => const MessagesScreen(),
                  routes: [
                    GoRoute(
                      path: 'chat/:conversationId',
                      builder: (context, state) => ChatScreen(
                        conversationId: state.pathParameters['conversationId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Tab 3: Profile
            StatefulShellBranch(
              navigatorKey: _profileNavigatorKey,
              routes: [
                GoRoute(
                  path: AppRoutes.profile,
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),

        // ─── Detail Screens (pushed on top of shell) ────────────────
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
          builder: (context, state) => const CheckoutScreen(),
        ),

        GoRoute(
          path: AppRoutes.paymentSuccess,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const PaymentSuccessScreen(),
        ),

        GoRoute(
          path: AppRoutes.search,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const SearchScreen(),
        ),

        GoRoute(
          path: AppRoutes.notifications,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const NotificationsScreen(),
        ),

        GoRoute(
          path: AppRoutes.editProfile,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const EditProfileScreen(),
        ),

        GoRoute(
          path: AppRoutes.appSettings,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const AppSettingsScreen(),
        ),
      ],

      // ─── Error Page ──────────────────────────────────────────────
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'الصفحة غير موجودة',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
