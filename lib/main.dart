import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:food_truck_finder_user_app/api/app_api.dart';
import 'package:food_truck_finder_user_app/api/auth/auth.dart';
import 'package:food_truck_finder_user_app/api/notification_service.dart';
import 'package:food_truck_finder_user_app/app_url.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/language_provider.dart';
import 'package:food_truck_finder_user_app/router/custom_back_button_dispatcher.dart';
import 'package:food_truck_finder_user_app/router/router.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      await AuthHelper.init();
      await UserAuthManager.init();
      AppApi.init(AppUrl.apiUrl);
      NotificationService.initialize(AppUrl.apiUrl);

      runApp(const MyApp());
    },
    (dynamic error, StackTrace stackTrace) {
      if (kDebugMode) {
        print('runZonedGuarded: Caught error: $error');
        print(stackTrace);
      }
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late LanguageProvider _languageProvider;
  bool _isLanguageInitialized = false;

  void _requestAppTracking() async {
    await AppTrackingTransparency.requestTrackingAuthorization();
    if (await AppTrackingTransparency.trackingAuthorizationStatus == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 200));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  @override
  void initState() {
    super.initState();
    _languageProvider = LanguageProvider();
    _initializeLanguage();

    _requestAppTracking();

    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _initializeLanguage() async {
    await _languageProvider.initialize();
    setState(() {
      _isLanguageInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLanguageInitialized) {
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
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              theme: themeManager.currentTheme,
              title: 'Food Truck',
            ),
          );
        },
      ),
    );
  }
}
