// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static late String apiBaseUrl;

  static Future<void> initialize(String apiUrl) async {
    apiBaseUrl = apiUrl;

    // Android: Request permission (optional for Android 13+)
    await _firebaseMessaging.requestPermission();

    // Foreground message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
      // Show a toast/snackbar if desired
    });

    // Background message opened
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification tapped: ${message.data}');
    });

    // Token generation
    final token = await _firebaseMessaging.getToken();
    // print('FCM Token: $token');
    if (token != null) {
      await _saveTokenToBackend(token);
    }

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      await _saveTokenToBackend(newToken);
    });
  }

  static Future<void> _saveTokenToBackend(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/fcm-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );
      if (response.statusCode == 200) {
        print('FCM token saved successfully');
      } else {
        print('Failed to save FCM token');
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}
