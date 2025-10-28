// ignore_for_file: constant_pattern_never_matches_value_type

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_truck_finder_user_app/api/app_api.dart';
import 'package:food_truck_finder_user_app/api/auth/auth_exception.dart';
import 'package:food_truck_finder_user_app/api/core/exceptions/http_client_exception.dart';
import 'package:food_truck_finder_user_app/api/core/exceptions/validation_exception.dart';
import 'package:food_truck_finder_user_app/api/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuthManager {
  static late final FlutterSecureStorage _secureStorage;
  static late final SharedPreferences _sharedPreferences;

  static Future<void>? _refreshBearerTokenFuture;

  static Future<void> init() async {
    _secureStorage = FlutterSecureStorage();
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> checkUser() async {
    try {
      await _reloadCachedUser();
    } catch (e) {
      rethrow;
    }
  }

  static Future<({bool succeeded, String? errorMessage})> googleLogin(String token) async {
    await _saveSessionTokens(token, 'refreshToken');
    await checkUser();

    return (succeeded: true, errorMessage: null);
  }

  static Future<({bool succeeded, String? errorMessage})> appleLogin(String token) async {
    await _saveSessionTokens(token, 'refreshToken');
    await checkUser();

    return (succeeded: true, errorMessage: null);
  }

  static Future<({bool succeeded, String? errorMessage})> login(String email, String password) async {
    try {
      final (bearerToken, refreshToken) = await AppApi.user.login(email, password);
      await _saveSessionTokens(bearerToken, refreshToken);

      await checkUser();

      return (succeeded: true, errorMessage: null);
      // ignore: unused_catch_stack
    } catch (e, s) {
      final errorCode = switch (e) {
        AuthException() => e.reason?.errorCode,
        HttpClientException() => e.errorCode,
        ValidationException() => 422,
        _ => null,
      };

      if (errorCode == 422) {
        rethrow;
      }
      final message = switch (errorCode) {
        'Unauthorized' => 'Invalid Mobile Number or Password.',
        'Blocked' => 'Your account has been deactivated. Please contact support.',
        _ => 'An error occurred. Please try again later.',
      };
      return (succeeded: false, errorMessage: message);
    }
  }

  static Future<bool> signUp({
    required String name,
    required String email,

    required String password,
    required String passwordConfirmation,
    Map<String, dynamic>? extraFields,
  }) async {
    try {
      bool success = await AppApi.user.signUp(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        extraFileds: extraFields,
      );
      return success;
      // ignore: unused_catch_stack
    } catch (e, s) {
      rethrow;
    }
  }

  static Future<void> refreshBearerToken() async {
    performRefresh() async {
      if (currentUser == null) {
        throw AuthException('User is not logged in.');
      }

      final refreshToken = await getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        throw AuthException('Refresh token is missing.');
      }

      // final (newBearerToken, newRefreshToken, changePasswordToken) =
      //     await AmigoalApi.user
      //         .refreshToken(currentUser!.email ?? '', refreshToken);

      // await _saveSessionTokens(
      //   newBearerToken,
      //   newRefreshToken,
      //   changePasswordToken,
      // );
    }

    if (_refreshBearerTokenFuture != null) {
      // This is to prevent multiple refreshes from happening at the same time
      return _refreshBearerTokenFuture;
    }

    try {
      _refreshBearerTokenFuture = performRefresh();
      await _refreshBearerTokenFuture;
    } finally {
      _refreshBearerTokenFuture = null;
    }
  }

  static Future<void> logout() async {
    try {
      await AppApi.user.logout();
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
    }

    await _removeSession();
  }

  static Future<bool> deleteAccount() async {
    try {
      await AppApi.user.deleteAccount();
      await _removeSession();
      return true;
    } catch (e, s) {
      if (kDebugMode) {
        print('Delete account error: $e');
        print(s);
      }
      return false;
    }
  }

  static Future<String?> getBearerToken() {
    return _secureStorage.read(key: 'bearerToken');
  }

  static Future<String?> getChangePasswordToken() {
    return _secureStorage.read(key: 'changePasswordToken');
  }

  static Future<String?> getRefreshToken() {
    return _secureStorage.read(key: 'refreshToken');
  }

  static User? get currentUser {
    final user = _readCachedUser();
    return user;
  }

  // static bool get isAdmin {
  //   final user = currentUser;
  //   return user!.types.contains(UserType.Admin);
  // }

  static bool get isLoggedIn {
    return _readCachedUser() != null;
  }

  static Future<void> _saveSessionTokens(String bearerToken, String refreshToken) async {
    await _secureStorage.write(key: 'bearerToken', value: bearerToken);
    await _secureStorage.write(key: 'refreshToken', value: refreshToken);

    await _sharedPreferences.setString('sessionCreatedAt', DateTime.now().toUtc().toIso8601String());
  }

  static Future<void> _removeSession() async {
    await _secureStorage.delete(key: 'bearerToken');
    await _secureStorage.delete(key: 'refreshToken');
    await _sharedPreferences.remove('user');
    await _sharedPreferences.remove('sessionCreatedAt');
  }

  static Future<void> _reloadCachedUser() async {
    try {
      final user = await AppApi.user.me();
      await _sharedPreferences.setString('user', jsonEncode(user.toJson()));
    } on AuthException {
      await _removeSession();
      rethrow;
    }
  }

  static Future<void> reloadUserAndCache() async {
    await _reloadCachedUser();
  }

  static User? _readCachedUser() {
    final userJson = _sharedPreferences.getString('user');

    if (userJson == null) {
      return null;
    }

    try {
      return User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }

      return null;
    }
  }
}
