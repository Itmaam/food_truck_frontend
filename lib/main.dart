import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:food_truck_finder_user_app/api/app_api.dart';
import 'package:food_truck_finder_user_app/api/auth/auth.dart';
import 'package:food_truck_finder_user_app/api/notification_service.dart';
import 'package:food_truck_finder_user_app/app_url.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/language_provider.dart';
import 'package:food_truck_finder_user_app/router/custom_back_button_dispatcher.dart';
import 'package:food_truck_finder_user_app/router/router.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/theme.dart';

import 'firebase_options.dart';

/// Robust app entry that ensures Firebase and messaging are initialized
/// before any plugin-based calls are made from Dart.
Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase first (this creates the default app instance).
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      // Initialize Firebase Messaging only after Firebase is ready.
      // Request permissions for notifications (iOS/Android where applicable).
      try {
        await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);
      } catch (_) {
        // Ignore; platforms without messaging will throw here.
      }

      // On iOS, request App Tracking Transparency permission (safe to call only when not web).
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        try {
          final status = await AppTrackingTransparency.requestTrackingAuthorization();
          if (status == TrackingStatus.notDetermined) {
            // small delay then request again if needed
            await Future.delayed(const Duration(milliseconds: 200));
            await AppTrackingTransparency.requestTrackingAuthorization();
          }
        } catch (_) {
          // ignore ATT errors
        }
      }

      // Initialize app-specific helpers (if present) after Firebase is ready.
      try {
        await AuthHelper.init();
      } catch (_) {}
      try {
        await UserAuthManager.init();
      } catch (_) {}

      AppApi.init(AppUrl.apiUrl);
      // NotificationService.initialize uses FirebaseMessaging internally — await it.
      try {
        await NotificationService.initialize(AppUrl.apiUrl);
      } catch (_) {}

      // Preferred device orientation and status bar appearance.
      await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      runApp(const MyApp());
    },
    (Object error, StackTrace stack) {
      if (kDebugMode) {
        // Print errors in debug to help trace initialization issues.
        debugPrint('Uncaught error: $error');
        debugPrintStack(stackTrace: stack);
      }
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LanguageProvider _languageProvider = LanguageProvider();
  bool _languageReady = false;

  @override
  void initState() {
    super.initState();
    _initLanguage();
  }

  Future<void> _initLanguage() async {
    try {
      await _languageProvider.initialize();
    } catch (_) {}
    if (mounted) {
      setState(() => _languageReady = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_languageReady) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeManager>(create: (_) => ThemeManager.instance),
        ChangeNotifierProvider<LanguageProvider>.value(value: _languageProvider),
      ],
      child: Consumer2<ThemeManager, LanguageProvider>(
        builder: (context, themeManager, languageProvider, child) {
          final isRTL = languageProvider.locale.languageCode == 'ar';
          return Directionality(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Food Truck',
              theme: themeManager.currentTheme,
              routeInformationProvider: router.routeInformationProvider,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              backButtonDispatcher: CustomBackButtonDispatcher(router),
              locale: languageProvider.locale,
              supportedLocales: LanguageProvider.supportedLocales,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                AppLocalizationDelegate(),
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                if (locale == null) return supportedLocales.first;
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) return supportedLocale;
                }
                return supportedLocales.first;
              },
            ),
          );
        },
      ),
    );
  }
}
