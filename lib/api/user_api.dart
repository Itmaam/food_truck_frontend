import 'dart:developer';

import 'package:food_truck_finder_user_app/api/auth/auth.dart';
import 'package:food_truck_finder_user_app/api/core/base_crud_api.dart';
import 'package:food_truck_finder_user_app/api/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io' show Platform;

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class UserApi extends BaseCRUDApi<User> {
  UserApi(String apiUrl) : super('$apiUrl/user');

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<bool> signInWithGoogle() async {
    try {
      // Sign out first to ensure clean state
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        log('Google Sign-In: User cancelled the sign-in');
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        log('Google Sign-In: Failed to get ID token');
        return false;
      }

      log('Google Sign-In: Successfully got user data for ${googleUser.email}');

      try {
        final response = await httpClient.post(
          '/auth/google/auth',
          body: {
            'token': googleAuth.idToken,
            'platform':
                Platform.isIOS
                    ? 'ios'
                    : Platform.isAndroid
                    ? 'android'
                    : 'web',
            'access_token': googleAuth.accessToken,
            'email': googleUser.email,
            'name': googleUser.displayName,
          },
        );

        if (response['token'] != null) {
          await UserAuthManager.googleLogin(response['token']);
          log('Google Sign-In: Successfully authenticated with server');
          return true;
        } else {
          log('Google Sign-In: Server did not return a token');
          return false;
        }
      } catch (err) {
        log('Google Sign-In: Server authentication failed: $err');
        rethrow;
      }
    } catch (error) {
      log('Google Sign-In: General error: $error');
      rethrow;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      if (credential.identityToken == null) {
        log('Apple Sign-In: Failed to get ID token');
        return false;
      }

      log('Apple Sign-In: Successfully got user data for ${credential.email}');

      try {
        // Get the name
        final fullName =
            credential.givenName != null ? '${credential.givenName} ${credential.familyName}' : 'apple user';
        final response = await httpClient.post(
          '/auth/apple/auth',
          body: {
            'name': fullName,
            'identity_token': credential.identityToken,
            'authorization_code': credential.authorizationCode,
          },
        );

        if (response['token'] != null) {
          await UserAuthManager.appleLogin(response['token']);
          log('Apple Sign-In: Successfully authenticated with server');
          return true;
        } else {
          log('Apple Sign-In: Server did not return a token');
          return false;
        }
      } catch (err) {
        log('Apple Sign-In: Server authentication failed: $err');
        rethrow;
      }
    } catch (error) {
      log('Apple Sign-In: General error: $error');
      rethrow;
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    Map<String, dynamic>? extraFileds,
  }) async {
    final body = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      if (extraFileds != null) ...extraFileds,
    };

    final response = await httpClient.post('/auth/signup', body: body);

    return response['success'] as bool;
  }

  Future<(String, String)> login(String email, String password) async {
    final response = await httpClient.post('/auth/login', body: {'email': email, 'password': password});
    final bearerToken = response['bearerToken'] as String;
    final refreshToken = response['refreshToken'] as String;

    return (bearerToken, refreshToken);
  }

  Future<(String, String, String)> refreshToken(String email, String refreshToken) async {
    final response = await httpClient.post(
      '/refresh-token',
      body: {'email': email, 'refreshTokenString': refreshToken},
    );

    final bearerToken = response['bearerToken'] as String;
    final changePasswordToken = response['changePasswordToken'] as String;

    return (
      bearerToken,
      refreshToken, // Refresh token remains the same but we still return it for consistency
      changePasswordToken,
    );
  }

  Future<void> logout() async {
    await httpClient.post('/logout');
  }

  Future<void> triggerForgotPassword(String email) async {
    await httpClient.get('/reset-password/$email');
  }

  Future<void> resetPassword(int userId, String code, String password) async {
    await httpClient.post(
      '/reset-password',
      body: {'userId': userId, 'code': code, 'password': password, 'confirmPassword': password},
    );
  }

  Future<void> changePassword(
    String changePasswordToken,
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    await httpClient.post(
      '/change-password',
      body: {
        'changePasswordToken': changePasswordToken,
        'confirmPassword': confirmPassword,
        'newPassword': newPassword,
        'oldPassword': oldPassword,
      },
    );
  }

  Future<User> me() async {
    final response = await httpClient.get('/me');
    return User.fromJson(response as Map<String, dynamic>);
  }

  Future<bool> deleteAccount() async {
    try {
      await httpClient.delete('/me');
      return true;
    } catch (e) {
      log('Delete account error: $e');
      rethrow;
    }
  }

  @override
  User fromJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(User entity) {
    return entity.toJson();
  }
}
