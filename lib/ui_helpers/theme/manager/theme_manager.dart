import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/manager/i_theme_manager.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/types/theme_dark.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/types/theme_light.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeEnum { dark, light }

class ThemeManager extends ChangeNotifier implements IThemeManager {
  static const String _themePreferenceKey = 'selected_theme';
  static ThemeManager? _instance;
  static ThemeManager get instance {
    _instance ??= ThemeManager._init();
    return _instance!;
  }

  ThemeManager._init();

  @override
  ThemeData currentTheme = ThemeEnum.light.generateTheme;
  ThemeEnum currentThemeEnum = ThemeEnum.light;

  bool get isDark => currentThemeEnum == ThemeEnum.dark;

  Future<void> initTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? savedThemeString = prefs.getString(_themePreferenceKey);

    if (savedThemeString != null) {
      final ThemeEnum savedTheme = ThemeEnum.values.firstWhere(
        (ThemeEnum theme) => theme.toString() == savedThemeString,
        orElse: () => ThemeEnum.light,
      );
      changeTheme(savedTheme);
    } else {
      final Brightness brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (brightness == Brightness.dark) {
        changeTheme(ThemeEnum.dark);
      } else {
        changeTheme(ThemeEnum.light);
      }
    }
  }

  @override
  void changeTheme(ThemeEnum newTheme, {bool saveTheme = true}) async {
    if (newTheme != currentThemeEnum) {
      currentTheme = newTheme.generateTheme;
      currentThemeEnum = newTheme;
      notifyListeners();

      if (saveTheme) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(_themePreferenceKey, newTheme.toString());
      }
    }
  }
}

extension ThemeEnumExtension on ThemeEnum {
  ThemeData get generateTheme {
    switch (this) {
      case ThemeEnum.light:
        return ThemeLight.instance.theme!;
      case ThemeEnum.dark:
        return ThemeDark.instance.theme!;
    }
  }
}
