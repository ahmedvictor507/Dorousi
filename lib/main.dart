import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'core/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/auth/providers/auth_provider.dart';

/// Global key to access ScaffoldMessenger without context
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Handle errors that happen outside of the Flutter framework
  PlatformDispatcher.instance.onError = (error, stack) {
    // Log the error (e.g., to Sentry or Firebase)
    debugPrint('Global Error: $error');

    scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text('حدث خطأ غير متوقع. يرجى المحاولة لاحقاً'),
        backgroundColor: Colors.redAccent,
      ),
    );
    return true;
  };

  // Lock orientation to portrait for consistent mobile UX
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          final provider = AuthProvider();
          provider.checkLoginState();
          return provider;
        }),
      ],
      child: const DourousiApp(),
    ),
  );
}

class DourousiApp extends StatefulWidget {
  const DourousiApp({super.key});

  @override
  State<DourousiApp> createState() => _DourousiAppState();
}

class _DourousiAppState extends State<DourousiApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Initialize router once with the stable AuthProvider instance
    _router = AppRouter.router(context.read<AuthProvider>());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'دروسي - Dourousi',
      debugShowCheckedModeBanner: false,

      // ─── Theme ──────────────────────────────────────
      theme: DourousiTheme.lightTheme,

      // ─── RTL Arabic Locale ──────────────────────────
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ─── Go Router ──────────────────────────────────
      routerConfig: _router,
    );
  }
}
