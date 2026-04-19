import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/auth/providers/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

  runApp(const DourousiApp());
}

class DourousiApp extends StatelessWidget {
  const DourousiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.router(context);

          return MaterialApp.router(
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
            routerConfig: router,
          );
        },
      ),
    );
  }
}