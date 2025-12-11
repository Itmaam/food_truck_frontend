import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:food_truck_finder_user_app/api/auth/auth_exception.dart';
import 'package:food_truck_finder_user_app/api/auth/auth_helper.dart';
import 'package:food_truck_finder_user_app/api/core/exceptions/http_client_exception.dart';
import 'package:food_truck_finder_user_app/api/core/exceptions/http_client_retry_exception.dart';
import 'package:food_truck_finder_user_app/api/core/exceptions/request_timeout_exception.dart';
import 'package:food_truck_finder_user_app/api/core/exceptions/server_errors.dart';
import 'package:food_truck_finder_user_app/api/core/exceptions/validation_exception.dart';
import 'package:food_truck_finder_user_app/api/utils/json_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

HttpClient createHttpClient([String baseUrl = '']) {
  return HttpClient(
    baseUrl,
    (request) async {
      final bearerToken = await AuthHelper.getBearerToken();
      if (bearerToken != null) {
        request.headers.putIfAbsent('Authorization', () => 'Bearer $bearerToken');
      }
    },
    (response) async {
      final body = tryJsonDecode(response.body);
      final errorCode = body is Map ? body['errorCode'] : null;

      final isAuthRequired = response.statusCode == HttpStatus.unauthorized;
      final isUserDeactivated = response.statusCode == HttpStatus.forbidden && errorCode == 'Blocked';

      if (isAuthRequired || isUserDeactivated) {
        final message = isUserDeactivated ? 'Deactivated' : 'Unauthorized';

        throw AuthException(message, HttpClientException(message, response.request!, response));
      }
    },
  );
}

class HttpClient {
  final _defaultHeaders = {'Content-Type': 'application/json', 'Accept': 'application/json'};
  final http.Client _inner = http.Client();
  final String baseUrl;
  final Duration requestTimeout;

  final Future<void> Function(http.BaseRequest request)? requestInterceptor;
  final Future<void> Function(http.Response response)? responseInterceptor;

  HttpClient([
    this.baseUrl = '',
    this.requestInterceptor,
    this.responseInterceptor,
    this.requestTimeout = const Duration(seconds: 30),
  ]);

  Future<dynamic> get(String url, {Map<String, String>? headers, Map<String, dynamic>? queryParameters}) async {
    return send('GET', url, headers: headers, queryParameters: queryParameters);
  }

  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    return send('POST', url, headers: headers, queryParameters: queryParameters, body: body);
  }

  Future<dynamic> put(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    return send('PUT', url, headers: headers, queryParameters: queryParameters, body: body);
  }

  Future<dynamic> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    return send('DELETE', url, headers: headers, queryParameters: queryParameters, body: body);
  }

  Future<dynamic> send(
    String method,
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    // Set Accept-Language from saved locale
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeTag = prefs.getString('selected_locale') ?? 'en';
      _defaultHeaders['Accept-Language'] = localeTag.split('-')[0];
    } catch (e) {
      _defaultHeaders['Accept-Language'] = 'en';
    }

    try {
      final isMultipartFormData =
          headers?.containsKey('Content-Type') == true && headers!['Content-Type'] == 'multipart/form-data';

      final request =
          isMultipartFormData
              ? http.MultipartRequest(method, _resolveUri(url, queryParameters))
              : http.Request(method, _resolveUri(url, queryParameters));

      request.headers.addAll(_defaultHeaders);
      request.headers.addAll(headers ?? {});

      if (request is http.MultipartRequest) {
        (body as Map<String, dynamic>).forEach((key, value) {
          if (value is http.MultipartFile) {
            request.files.add(value);
          } else {
            request.fields[key] = value.toString();
          }
        });
      }

      if (request is http.Request) {
        request.body = jsonEncode(body);
      }

      if (requestInterceptor != null) {
        await requestInterceptor!(request);
      }

      final response = await http.Response.fromStream(await _inner.send(request)).timeout(
        requestTimeout,
        onTimeout: () {
          throw RequestTimeoutException(
            message: 'Request timeout exceeded. Please check your connection and try again.',
          );
        },
      );

      final responseBody = tryJsonDecode(response.body) ?? response.body;

      if (responseInterceptor != null) {
        await responseInterceptor!(response);
      }

      if (response.statusCode >= 400) {
        if (response.statusCode == 422) {
          throw ValidationException(responseBody['errors']);
        }
        throw HttpClientException('Request failed with status ${response.statusCode}', request, response);
      }

      return responseBody;
    } on HttpClientRetryException {
      // Retry the request once
      return send(method, url, headers: headers, queryParameters: queryParameters, body: body);
    } on SocketException catch (e) {
      log('Socket Exception: ${e.message}');
      throw ServerConnectionError(message: 'Unable to connect to server. Please check your internet connection.');
    } on ServerConnectionError {
      rethrow;
    } on RequestTimeoutException {
      rethrow;
    } on ValidationException {
      rethrow;
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      log('Unexpected HTTP error: $e');
      log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Uri _resolveUri(String url, [Map<String, dynamic>? queryParameters]) {
    final fullUrl = '$baseUrl$url';

    if (queryParameters == null) {
      return Uri.parse(fullUrl);
    }

    final stringQueryParameters = queryParameters.map(
      (key, value) => MapEntry(key, switch (value) {
        List() || null => value,
        _ => value.toString(),
      }),
    );

    stringQueryParameters.removeWhere((_, value) => value == null || value == '');

    return Uri.parse(fullUrl).replace(queryParameters: stringQueryParameters);
  }
}
