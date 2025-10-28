import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lib/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Clear any existing preferences for testing
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('selected_locale');
  
  print('Testing Language Provider...');
  
  // Test 1: Initialize with device language
  print('\n1. Testing device language detection:');
  final provider = LanguageProvider();
  await provider.initialize();
  print('Initialized locale: ${provider.locale}');
  
  // Test 2: Change language and verify persistence
  print('\n2. Testing language change and persistence:');
  await provider.setLocale(const Locale('ar'));
  print('Changed to Arabic: ${provider.locale}');
  
  // Verify it's saved
  final savedLang = prefs.getString('selected_locale');
  print('Saved in preferences: $savedLang');
  
  // Test 3: Create new provider and verify it loads saved language
  print('\n3. Testing persistence across provider instances:');
  final newProvider = LanguageProvider();
  await newProvider.initialize();
  print('New provider loaded locale: ${newProvider.locale}');
  
  // Test 4: Toggle language
  print('\n4. Testing language toggle:');
  await newProvider.toggleLanguage();
  print('After toggle: ${newProvider.locale}');
  
  print('\nAll tests completed!');
}
