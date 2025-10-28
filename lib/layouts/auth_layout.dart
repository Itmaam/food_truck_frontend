import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/localization/widgets/switch_language.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/widgets/toggle_theme_icon.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  const AuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.allLarge,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[ToggleThemeIcon(), SwitchLanguage()],
              ),
              Expanded(child: SingleChildScrollView(child: child)),
            ],
          ),
        ),
      ),
    );
  }
}
