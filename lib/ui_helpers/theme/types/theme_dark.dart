// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/application/application_theme.dart';

class ThemeDark extends ApplicationTheme {
  static ThemeDark? _instance;
  static ThemeDark get instance {
    _instance ??= ThemeDark._init();
    return _instance!;
  }

  ThemeDark._init();

  @override
  ThemeData? get theme {
    // Colors
    const Color primaryColor = Color(0xFF66B2B2); // Confirmed primary color
    const Color backgroundColor = Color(0xFF0C1415);
    const Color surfaceColor = Color(0xFF182724);
    const Color secondaryColor = Color(0xFFF8984A);
    const Color errorColor = Color(0xFFFF3B30);
    const Color appBarColor = Color(0xFF1E2526);
    const Color bottomAppBarColor = Color.fromARGB(4, 30, 37, 38);
    const Color fabColor = Color(0xFF18BC94);
    const MaterialColor disabledColor = Colors.grey;

    // Text Styles
    const TextStyle bodyLargeStyle = TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal);
    const TextStyle bodyMediumStyle = TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal);
    const TextStyle titleLargeStyle = TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
    const TextStyle labelLargeStyle = TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
    final TextStyle bodySmallStyle = TextStyle(
      color: Colors.white.withValues(alpha: 0.5),
      fontSize: 12,
      fontWeight: FontWeight.normal,
    );
    const TextStyle appBarTitleStyle = TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
    final TextStyle inputLabelStyle = TextStyle(
      color: Colors.white.withValues(alpha: 0.5),
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );
    const TextStyle snackBarContentStyle = TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal);
    const TextStyle tooltipTextStyle = TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal);
    const TextStyle tabLabelStyle = TextStyle(color: secondaryColor, fontSize: 16, fontWeight: FontWeight.bold);
    final TextStyle tabUnselectedLabelStyle = TextStyle(
      color: Colors.white.withValues(alpha: 0.5),
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );

    const ColorScheme colorScheme = ColorScheme.dark(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      surface: surfaceColor,
      error: errorColor,
      onError: Colors.white,
    );

    return ThemeData(
      // Core Properties
      brightness: Brightness.dark,
      fontFamily: 'Cairo',
      colorScheme: colorScheme,

      // Color Properties
      primaryColor: primaryColor,
      primaryColorLight: const Color(0xFF00E5DB),
      primaryColorDark: const Color(0xFF008F8B),
      canvasColor: surfaceColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: surfaceColor.withValues(alpha: 0.5),
      dividerColor: Colors.white.withValues(alpha: 0.2),
      highlightColor: primaryColor.withValues(alpha: 0.2),
      splashColor: primaryColor.withValues(alpha: 0.2),
      unselectedWidgetColor: Colors.white.withValues(alpha: 0.5),
      disabledColor: disabledColor,
      secondaryHeaderColor: const Color(0xFF424242),
      indicatorColor: secondaryColor,
      hintColor: Colors.white.withValues(alpha: 0.5),
      shadowColor: primaryColor.withValues(alpha: 0.3),

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: appBarColor,
        elevation: 4.0,
        iconTheme: IconThemeData(color: secondaryColor),
        titleTextStyle: appBarTitleStyle,
        centerTitle: true,
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
                states.contains(WidgetState.pressed) ? primaryColor.withValues(alpha: 0.2) : null,
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
          borderSide: const BorderSide(color: primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: primaryColor),
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
        side: BorderSide.none,
        checkColor: const WidgetStatePropertyAll<Color>(Colors.black),
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
      //   labelColor: secondaryColor,
      //   unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
      //   indicator: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12.0)),
      //   labelStyle: tabLabelStyle,
      //   unselectedLabelStyle: tabUnselectedLabelStyle,
      // ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryColor,
        contentTextStyle: snackBarContentStyle,
        actionTextColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8.0)),
        textStyle: tooltipTextStyle,
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: backgroundColor),

      // Dialog
      dialogTheme: const DialogThemeData(backgroundColor: surfaceColor),

      // Text Theme
      textTheme: TextTheme(
        bodyLarge: bodyLargeStyle,
        bodyMedium: bodyMediumStyle,
        titleLarge: titleLargeStyle,
        labelLarge: labelLargeStyle,
        bodySmall: bodySmallStyle,
      ),
    );
  }
}
