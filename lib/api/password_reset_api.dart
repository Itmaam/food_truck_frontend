import 'package:food_truck_finder_user_app/api/core/base_crud_api.dart';

class PasswordResetApi extends BaseCRUDApi<dynamic> {
  PasswordResetApi(super.apiUrl);

  Future<Map<String, dynamic>> requestOtp(String email) async {
    final response = await httpClient.post('/password/otp', body: {'email': email});
    if (response != null) {
      return response;
    } else {
      throw Exception('Failed to request OTP');
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await httpClient.post('/password/verify', body: {'email': email, 'otp': otp});
      return response;
    } catch (e) {
      throw Exception('OTP verification failed');
    }
  }

  Future<void> resetPassword(String token, String password, String passwordConfirmation) async {
    try {
      return await httpClient.post(
        '/password/reset',

        body: {'reset_token': token, 'password': password, 'password_confirmation': passwordConfirmation},
      );
    } catch (e) {
      throw Exception('Password reset failed');
    }
  }

  @override
  Map<String, dynamic> toJson(dynamic entity) {
    return entity.toJson();
  }

  @override
  fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
