// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/application/application_theme.dart';

class ThemeLight extends ApplicationTheme {
  static ThemeLight? _instance;
  static ThemeLight get instance {
    _instance ??= ThemeLight._init();
    return _instance!;
  }

  ThemeLight._init();

  @override
  ThemeData? get theme {
    // Colors
    const Color primaryColor = Color(0xFF66B2B2); // Confirmed primary color
    const Color backgroundColor = Color(0xFFF5F5F5);
    const Color surfaceColor = Color(0xFFFFFFFF);
    const Color secondaryColor = Color(0xFFF8984A);
    const Color errorColor = Color(0xFFFF5252);
    const Color appBarColor = Colors.white;
    const Color bottomAppBarColor = Colors.white;
    const Color fabColor = Color.fromARGB(255, 0, 17, 17);
    const MaterialColor disabledColor = Colors.grey;

    // Text Styles
    const TextStyle bodyLargeStyle = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal);
    const TextStyle bodyMediumStyle = TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal);
    const TextStyle titleLargeStyle = TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
    const TextStyle labelLargeStyle = TextStyle(color: fabColor, fontSize: 16, fontWeight: FontWeight.bold);
    const TextStyle bodySmallStyle = TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal);
    const TextStyle appBarTitleStyle = TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
    const TextStyle inputLabelStyle = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal);
    const TextStyle snackBarContentStyle = TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal);
    const TextStyle tooltipTextStyle = TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal);
    const TextStyle tabLabelStyle = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
    const TextStyle tabUnselectedLabelStyle = TextStyle(
      color: Colors.grey,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );

    const ColorScheme colorScheme = ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      error: errorColor,
    );

    return ThemeData(
      // Core Properties
      brightness: Brightness.light,
      fontFamily: 'Cairo',
      colorScheme: colorScheme,

      // Color Properties
      primaryColor: primaryColor,
      primaryColorLight: const Color(0xFF00E5DB),
      primaryColorDark: const Color(0xFF008F8B),
      canvasColor: surfaceColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: surfaceColor,
      dividerColor: Colors.grey.shade300,
      highlightColor: primaryColor.withValues(alpha: 0.2),
      splashColor: primaryColor.withValues(alpha: 0.2),
      unselectedWidgetColor: Colors.grey.shade600,
      disabledColor: disabledColor,
      secondaryHeaderColor: const Color(0xFFF7FAFC),
      indicatorColor: fabColor,
      hintColor: Colors.grey.shade500,
      shadowColor: Colors.black.withValues(alpha: 0.1),

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: appBarColor,
        elevation: 2.0,
        iconTheme: IconThemeData(color: fabColor),
        titleTextStyle: appBarTitleStyle,
      ),

      // Bottom App Bar
      bottomAppBarTheme: const BottomAppBarTheme(color: bottomAppBarColor, elevation: 4.0),

      // Buttons
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        buttonColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) => states.contains(WidgetState.disabled) ? disabledColor : Colors.white,
          ),
          textStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) =>
                TextStyle(color: states.contains(WidgetState.disabled) ? disabledColor : Colors.white),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) => states.contains(WidgetState.disabled) ? disabledColor : primaryColor,
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) =>
                states.contains(WidgetState.pressed) ? const Color(0xFF00E5DB).withValues(alpha: 0.2) : null,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(color: secondaryColor),
          side: const BorderSide(color: secondaryColor),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: fabColor,
        foregroundColor: Colors.white,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundColor,
        labelStyle: inputLabelStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: fabColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: fabColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: errorColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.3)),
        ),
      ),

      // Checkbox, Radio, Switch
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: secondaryColor, width: 2, strokeAlign: 20),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: secondaryColor.withAlpha(55), width: 2),
          borderRadius: BorderRadius.circular(4.0),
        ),
        checkColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) return disabledColor;
          if (states.contains(WidgetState.selected)) return primaryColor;
          return null;
        }),
        fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) return disabledColor;
          if (states.contains(WidgetState.selected)) return secondaryColor;
          return backgroundColor;
        }),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) return disabledColor;
          if (states.contains(WidgetState.selected)) return primaryColor;
          return null;
        }),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) return disabledColor;
          if (states.contains(WidgetState.selected)) return primaryColor;
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) return disabledColor.withValues(alpha: 0.5);
          if (states.contains(WidgetState.selected)) return primaryColor.withValues(alpha: 0.5);
          return null;
        }),
      ),

      // Tab Bar
      // tabBarTheme: TabBarTheme(
      //   labelColor: fabColor,
      //   unselectedLabelColor: Colors.grey,
      //   indicator: BoxDecoration(color: fabColor, borderRadius: BorderRadius.circular(12.0)),
      //   labelStyle: tabLabelStyle,
      //   unselectedLabelStyle: tabUnselectedLabelStyle,
      // ),

      // SnackBar
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: fabColor,
        contentTextStyle: snackBarContentStyle,
        actionTextColor: Colors.white,
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: fabColor, borderRadius: BorderRadius.circular(8.0)),
        textStyle: tooltipTextStyle,
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: backgroundColor),

      // Dialog
      dialogTheme: const DialogThemeData(backgroundColor: surfaceColor),

      // Text Theme
      textTheme: const TextTheme(
        bodyLarge: bodyLargeStyle,
        bodyMedium: bodyMediumStyle,
        titleLarge: titleLargeStyle,
        labelLarge: labelLargeStyle,
        bodySmall: bodySmallStyle,
      ),
    );
  }
}
