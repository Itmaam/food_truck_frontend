
import 'package:food_truck_finder_user_app/api/core/exceptions/http_client_exception.dart';

class AuthException {
  final String message;
  final HttpClientException? reason;

  AuthException([this.message = 'Authentication failed.', this.reason]);
}
