// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.25:8080',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        responseType: ResponseType.json,
        validateStatus: (_) => true,
      ),
    )
    ..interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        requestHeader: false,
      ),
    );

  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> payload,
  ) async {
    try {
      final res = await _dio.post('/api/register', data: payload);

      print('🔍 Status: ${res.statusCode}');
      print('🔍 Data: ${res.data}');

      if (res.statusCode == 201 && res.data is Map<String, dynamic>) {
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
      print('❌ DioException: ${e.type} ${e.message}');
      final data = e.response?.data;
      final msg =
          (data is Map && data['message'] != null)
              ? data['message']
              : 'Network error: ${e.message}';
      return {'success': false, 'message': msg, 'raw': data};
    } catch (e) {
      print('❌ Unexpected error: $e');
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  static Future<Map<String, dynamic>> login(
    Map<String, dynamic> payload,
  ) async {
    try {
      final res = await _dio.post('/api/login', data: payload);

      print('🔍 Status: ${res.statusCode}');
      print('🔍 Data: ${res.data}');

      if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
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
      print('❌ DioException: ${e.type} ${e.message}');
      final data = e.response?.data;
      final msg =
          (data is Map && data['message'] != null)
              ? data['message']
              : 'Network error: ${e.message}';
      return {'success': false, 'message': msg, 'raw': data};
    } catch (e) {
      print('❌ Unexpected error: $e');
      return {'success': false, 'message': 'Unexpected error: $e'};
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
}
