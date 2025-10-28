import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/manager/theme_manager.dart';
import 'package:provider/provider.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => watch<ThemeManager>().currentTheme;
}

extension ColorSchemeExtension on ColorScheme {
  Color get success => brightness == Brightness.light ? const Color(0xff4caf50) : const Color(0xff4caf50);

  Color get warning => brightness == Brightness.light ? const Color(0xffffc107) : const Color(0xffffc107);

  Color get info => brightness == Brightness.light ? const Color(0xff2196f3) : const Color(0xff2196f3);

  Color get danger => brightness == Brightness.light ? const Color(0xfff44336) : const Color(0xfff44336);
  Color get backgroundColorPrimary =>
      brightness == Brightness.light ? const Color(0xFF09DA82) : const Color(0xFF06704E);
}
