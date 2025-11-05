import 'package:dio/dio.dart';

import '../core/config/api_config.dart';
import '../core/errors/api_exception.dart';
import '../core/network/dio_client.dart';
import '../models/user.dart';
import '../services/secure_storage.dart';

class AuthRepository {
  final Dio _dio = DioClient.instance.dio;

  // Mobile token login via Sanctum PATs
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.mobileLogin,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String?;

      if (token == null || token.isEmpty) {
        throw ApiException(message: 'No token received from server');
      }

      // Save token to secure storage
      await SecureStorage.saveToken(token);

      // Parse and return user
      final userJson = data['user'] as Map<String, dynamic>;
      return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<UserModel> getUser() async {
    try {
      final response = await _dio.get(ApiConfig.getUser);
      final data = response.data as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiConfig.mobileLogout);
    } catch (_) {
      // Ignore server errors during logout
    } finally {
      await SecureStorage.clearToken();
    }
  }

  Future<String?> getStoredToken() => SecureStorage.getToken();

  // Mobile registration endpoint returns { user, token }
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String?;
      if (token == null || token.isEmpty) {
        throw ApiException(message: 'No token received from server');
      }

      await SecureStorage.saveToken(token);
      final userJson = data['user'] as Map<String, dynamic>;
      return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}
