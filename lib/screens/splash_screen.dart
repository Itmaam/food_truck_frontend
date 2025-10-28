// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/auth/user_auth_manager.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future<void>.delayed(const Duration(seconds: 3), () async {
      try {
        await UserAuthManager.checkUser();
        context.go('/home');
      } catch (err) {
        context.go('/auth/login');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: Image.asset('assets/icons/truck_me.png', height: MediaQuery.of(context).size.height / 4)),
            // const SizedBox(height: AppSpacing.small),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Text(
            //       'Nine The 9',
            //       style: Theme.of(
            //         context,
            //       ).textTheme.headlineLarge!.copyWith(color: context.theme.primaryColor, fontWeight: FontWeight.w900),
            //     ),
            //   ],
            // ),
            const SizedBox(height: AppSpacing.small),
          ],
        ),
      ),
    );
  }
}
