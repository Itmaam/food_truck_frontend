import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/manager/theme_manager.dart';

class ToggleThemeIcon extends StatefulWidget {
  const ToggleThemeIcon({super.key});

  @override
  State<ToggleThemeIcon> createState() => _ToggleThemeIconState();
}

class _ToggleThemeIconState extends State<ToggleThemeIcon> {
  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeManager.instance.currentThemeEnum == ThemeEnum.dark;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Tooltip(
        message: isDark ? 'Light Mode' : 'Dark Mode',
        key: ValueKey<bool>(isDark),
        verticalOffset: 20,
        preferBelow: false,
        showDuration: const Duration(milliseconds: 500),
        child: IconButton(
          key: ValueKey<bool>(isDark),
          icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: isDark ? Colors.white : Colors.black),
          onPressed: () {
            ThemeManager.instance.changeTheme(isDark ? ThemeEnum.light : ThemeEnum.dark);
            setState(() {
              isDark = !isDark;
            });
          },
        ),
      ),
    );
  }
}
