import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/api_config.dart';
import 'dio_interceptor.dart';

class DioClient {
  static DioClient? _instance;
  late Dio _dio;

  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(AuthInterceptor());

    // Add pretty logger in debug mode only
    if (kDebugMode) {
      // Helpful to see which backend we're hitting during dev
      // ignore: avoid_print
      print('[Dio] baseUrl => ${ApiConfig.baseUrl}');
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  Dio get dio => _dio;
}
