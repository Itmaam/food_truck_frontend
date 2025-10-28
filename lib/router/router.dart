import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/auth/auth.dart';
import 'package:food_truck_finder_user_app/screens/auth/otp_verification_screen.dart';
import 'package:food_truck_finder_user_app/screens/food_truck/activity_details_screen.dart';
import 'package:food_truck_finder_user_app/screens/food_truck/add_edit_activity_screen.dart';
import 'package:food_truck_finder_user_app/screens/auth/forget_password_screen.dart';
import 'package:food_truck_finder_user_app/screens/auth/reset_password_screen.dart';
import 'package:food_truck_finder_user_app/screens/auth/signin_screen.dart';
import 'package:food_truck_finder_user_app/screens/auth/signup_screen.dart';
import 'package:food_truck_finder_user_app/screens/contact_us_screen.dart';
import 'package:food_truck_finder_user_app/screens/favorites_screen.dart';
import 'package:food_truck_finder_user_app/screens/home/home_screen.dart';
import 'package:food_truck_finder_user_app/screens/notifications_screen.dart';
import 'package:food_truck_finder_user_app/screens/privacy_policy_screen.dart';
import 'package:food_truck_finder_user_app/screens/splash_screen.dart';
import 'package:food_truck_finder_user_app/screens/terms_and_conditions_screen.dart';
import 'package:food_truck_finder_user_app/screens/profile/user_profile_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',

  routes: <RouteBase>[
    GoRoute(name: 'splash', path: '/', builder: (BuildContext context, GoRouterState state) => const SplashScreen()),
    GoRoute(
      name: 'auth',
      path: '/auth',
      builder: (BuildContext context, GoRouterState state) => const SizedBox(), // Placeholder
      routes: <RouteBase>[
        GoRoute(
          name: 'login',
          path: 'login',
          builder: (BuildContext context, GoRouterState state) => const SigninScreen(),
        ),
        GoRoute(
          name: 'signup',
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) => const SignupScreen(),
        ),
        GoRoute(
          name: 'forget-password',
          path: 'forget-password',
          builder: (BuildContext context, GoRouterState state) => const ForgetPasswordScreen(),
        ),
        GoRoute(
          name: 'otp',
          path: 'verify-otp',
          builder: (BuildContext context, GoRouterState state) {
            return OtpVerificationScreen(email: state.uri.queryParameters['email'] ?? '');
          },
        ),
        GoRoute(
          name: 'reset-password',
          path: 'reset-password',
          builder: (BuildContext context, GoRouterState state) {
            final email = state.uri.queryParameters['email'] ?? '';
            final token = state.uri.queryParameters['token'] ?? '';
            if (token.isEmpty) {
              // Handle missing token - redirect back or show error
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.push('/auth/forget-password');
              });
              return const SizedBox(); // Temporary placeholder
            }

            return ResetPasswordScreen(email: email, token: token);
          },
        ),
      ],
    ),

    GoRoute(name: 'home', path: '/home', builder: (BuildContext context, GoRouterState state) => const HomeScreen()),
    GoRoute(
      name: 'profile',
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) => const UserProfileScreen(),
    ),
    GoRoute(
      name: 'add_activity',
      path: '/add_activity',
      builder: (BuildContext context, GoRouterState state) => const AddEditActivityScreen(),
    ),
    GoRoute(
      name: 'edit_activity',
      path: '/edit_activity/:id',
      builder:
          (BuildContext context, GoRouterState state) => AddEditActivityScreen(foodTruckId: state.pathParameters['id']),
    ),
    GoRoute(
      name: 'view_activity',
      path: '/view_activity/:id',
      builder: (context, state) => ActivityDetailsScreen(foodTruckId: state.pathParameters['id']!),
    ),
    GoRoute(
      name: 'favorites',
      path: '/favorites',
      builder: (BuildContext context, GoRouterState state) => const FavoritesScreen(),
    ),
    GoRoute(
      name: 'notifications',
      path: '/notifications',
      builder: (BuildContext context, GoRouterState state) => const NotificationsScreen(),
    ),
    GoRoute(
      name: 'privacy_policy',
      path: '/privacy_policy',
      builder: (BuildContext context, GoRouterState state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      name: 'tos',
      path: '/tos',
      builder: (BuildContext context, GoRouterState state) => const TermsAndConditionsScreen(),
    ),
    GoRoute(
      name: 'contact_us',
      path: '/contact_us',
      builder: (BuildContext context, GoRouterState state) => const ContactUsScreen(),
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    final bool inAuthGroup = state.matchedLocation.startsWith('/auth');
    final bool inSplash = state.fullPath == '/';

    final publicRoutes = [
      '/',
      '/home',
      '/privacy_policy',
      '/tos',
      '/contact_us',
      '/view_activity', // Allow viewing activities without login
    ];

    // Check if current route is public
    final isPublic = publicRoutes.any((route) => state.matchedLocation.startsWith(route));

    if (isPublic) {
      return null; // Allow access
    }

    if (inSplash) {
      return null;
    }

    String? token = await AuthHelper.getBearerToken();
    if (!inAuthGroup && token == null) {
      // Store the intended destination to redirect after login
      final intendedRoute = state.matchedLocation;
      if (intendedRoute != '/auth/login') {
        return '/auth/login?redirect=${Uri.encodeComponent(intendedRoute)}';
      }
      return '/auth/login';
    }
    return null;
  },
);
