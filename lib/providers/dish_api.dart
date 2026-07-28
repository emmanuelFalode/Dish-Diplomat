// ignore_for_file: avoid_print

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:foodapp/interceptors/auth_interceptors.dart';
import 'package:foodapp/models/login_model.dart';
import 'package:foodapp/models/login_response_model.dart';
import 'package:foodapp/providers/dio_exception.dart';
import 'package:foodapp/providers/service_api.dart';

class ApiService {
  static final Dio _dio = Dio(
      BaseOptions(
        baseUrl: ServiceApi.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        responseType: ResponseType.json,
      ),
    )

    ..interceptors.add(
      AuthInterceptors()
    )
    ..interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        requestHeader: true,
      ),
    );

  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> payload,
  ) async {
    try {
      final res = await _dio.post(ServiceApi.register, data: payload);

      return {"success": true, "data": res.data, "status": res.statusCode};
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }



  static Future<LoginResponseModel> login(LoginModel loginModel) async {
    try {
      final res = await _dio.post(ServiceApi.login, data: loginModel.toJson());

      return LoginResponseModel.fromJson(res.data);
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  } 


  static Future<Map<String, dynamic>> logout(String token) async {
    try {
      final res = await _dio.post(
        '/api/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(res.data);
      }
      final msg =
          (res.data is Map && (res.data as Map)['message'] != null)
              ? (res.data as Map)['message']
              : 'Request failed with status ${res.statusCode}';
      return {'success': false, 'message': msg, 'raw': res.data};
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg =
          (data is Map && data['message'] != null)
              ? data['message']
              : 'Network error: ${e.message}';
      return {'success': false, 'message': msg, 'raw': data};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  static Future<Map<String, dynamic>> me(String token) async {
    try {
      final res = await _dio.get(
        '/api/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(res.data);
      }

      final msg =
          (res.data is Map && (res.data as Map)['message'] != null)
              ? (res.data as Map)['message']
              : 'Request failed with status ${res.statusCode}';
      return {'success': false, 'message': msg, 'raw': res.data};
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg =
          (data is Map && data['message'] != null)
              ? data['message']
              : 'Network error: ${e.message}';
      return {'success': false, 'message': msg, 'raw': data};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> payload,
    String token,
  ) async {
    try {
      final res = await _dio.patch(
        '/api/me',
        data: payload,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if ((res.statusCode == 200 || res.statusCode == 204) &&
          res.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(res.data);
      }

      if (res.statusCode == 422 && res.data is Map<String, dynamic>) {
        return {
          'success': false,
          'message': 'Validation failed',
          'errors': (res.data as Map)['errors'] ?? res.data,
        };
      }

      final msg =
          (res.data is Map && (res.data as Map)['message'] != null)
              ? (res.data as Map)['message']
              : 'Request failed with status ${res.statusCode}';
      return {'success': false, 'message': msg, 'raw': res.data};
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg =
          (data is Map && data['message'] != null)
              ? data['message']
              : 'Network error: ${e.message}';
      return {'success': false, 'message': msg, 'raw': data};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  static Future<Map<String, dynamic>> changePassword(
    String currentPassword,
    String newPassword,
    String token,
  ) async {
    try {
      final res = await _dio.post(
        '/api/me/password',
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': newPassword,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(res.data);
      }

      if (res.statusCode == 422 && res.data is Map<String, dynamic>) {
        return {
          'success': false,
          'message': (res.data as Map)['message'] ?? 'Validation failed',
          'errors': (res.data as Map)['errors'] ?? res.data,
        };
      }

      final msg =
          (res.data is Map && (res.data as Map)['message'] != null)
              ? (res.data as Map)['message']
              : 'Request failed with status ${res.statusCode}';
      return {'success': false, 'message': msg, 'raw': res.data};
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg =
          (data is Map && data['message'] != null)
              ? data['message']
              : 'Network error: ${e.message}';
      return {'success': false, 'message': msg, 'raw': data};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  static Future<Map<String, dynamic>> verifyEmail(
    String email,
    String otp,
  ) async {
    try {
      final res = await _dio.post(
        '/api/verify-email',
        data: {'email': email, 'otp': otp},
        options: Options(headers: {'Accept': 'application/json'}),
      );
      if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(res.data);
      }
      final msg =
          (res.data is Map && (res.data as Map)['message'] != null)
              ? (res.data as Map)['message']
              : 'Request failed with status ${res.statusCode}';
      return {'success': false, 'message': msg, 'raw': res.data};
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg =
          (data is Map && data['message'] != null)
              ? data['message']
              : 'Network error: ${e.message}';
      return {'success': false, 'message': msg, 'raw': data};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }
}
