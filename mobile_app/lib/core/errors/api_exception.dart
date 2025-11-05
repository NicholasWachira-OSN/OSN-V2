import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: null,
        );
      case DioExceptionType.badResponse:
        return ApiException(
          message: _extractMessage(error.response),
          statusCode: error.response?.statusCode,
          data: error.response?.data,
        );
      case DioExceptionType.cancel:
        return ApiException(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection. Please check your network.',
        );
      default:
        return ApiException(
          message: 'Something went wrong. Please try again.',
        );
    }
  }

  static String _extractMessage(Response? response) {
    if (response?.data is Map) {
      final data = response!.data as Map;
      return data['message'] ?? data['error'] ?? 'Unknown error occurred';
    }
    return 'Server error: ${response?.statusCode}';
  }

  @override
  String toString() => message;
}
