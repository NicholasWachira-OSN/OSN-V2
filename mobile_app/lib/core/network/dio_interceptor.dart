import 'package:dio/dio.dart';

import '../../services/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Add Bearer token to all requests if available
    final token = await SecureStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle common errors globally
    if (err.response?.statusCode == 401) {
      // Token expired or invalid - clear it
      SecureStorage.clearToken();
    }
    handler.next(err);
  }
}
