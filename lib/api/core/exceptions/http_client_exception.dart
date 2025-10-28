// ignore_for_file: depend_on_referenced_packages

import 'package:food_truck_finder_user_app/api/utils/json_utils.dart';
import 'package:http/http.dart' as http;

/// Exception thrown when the [http.Client] encounters an error.
class HttpClientException implements Exception {
  final String message;
  final http.BaseRequest request;
  final http.BaseResponse response;

  HttpClientException(this.message, this.request, this.response);

  dynamic get body {
    if (response is http.Response) {
      final body = (response as http.Response).body;
      return tryJsonDecode(body) ?? body;
    }

    return null;
  }

  String? get errorCode =>
      body?['errorCode'] as String? ?? response.statusCode.toString();

  @override
  String toString() {
    final data = [
      'requestUrl: ${request.url}',
      'status: ${response.statusCode}',
      'headers: ${response.headers}',
      if (response is http.Response)
        'responseBody: ${(response as http.Response).body}',
    ].join('\n');
    return 'HttpClientException: $message\n$data';
  }
}
