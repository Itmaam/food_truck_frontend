import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  static const String _languageKey = 'selected_locale';
  static const List<String> _supportedLanguages = ['en', 'ar'];

  Locale get locale => _locale;

  /// Initialize the language provider with saved language or device language
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);

    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
    } else {
      // Get list of preferred locales from device
      final deviceLocales = PlatformDispatcher.instance.locales;

      // Try to find the first supported language from device preferences
      Locale? matchedLocale;
      for (var deviceLocale in deviceLocales) {
        if (_supportedLanguages.contains(deviceLocale.languageCode)) {
          matchedLocale = Locale(deviceLocale.languageCode);
          break;
        }
      }

      // Use matched locale or fallback to English
      _locale = matchedLocale ?? const Locale('en');
      await _saveLanguage(_locale.languageCode);
    }

    notifyListeners();
  }

  /// Set a new locale and persist it
  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners(); // Call this synchronously
    await _saveLanguage(newLocale.languageCode);
  }

  /// Toggle between English and Arabic without affecting layout
  Future<void> toggleLanguage() async {
    final newLanguage = _locale.languageCode == 'en' ? 'ar' : 'en';
    await setLocale(Locale(newLanguage));
  }

  /// Save language preference to SharedPreferences
  Future<void> _saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  /// Get list of supported locales
  static List<Locale> get supportedLocales {
    return _supportedLanguages.map((lang) => Locale(lang)).toList();
  }

  /// Check if a language is supported
  static bool isLanguageSupported(String languageCode) {
    return _supportedLanguages.contains(languageCode);
  }
}
