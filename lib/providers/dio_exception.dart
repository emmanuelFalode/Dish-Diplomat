import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  final String message;

  DioExceptions({
    required this.message,
  });

  static DioExceptions fromDioError(DioException dioError) {
    final responseData = dioError.response?.data;
    final statusCode = dioError.response?.statusCode;

    switch (dioError.type) {
      case DioExceptionType.cancel:
        return DioExceptions(
          message: "Request to API server was cancelled",
        );

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return DioExceptions(
          message: "Request timed out. Please try again.",
        );

      case DioExceptionType.badResponse:
        return DioExceptions(
          message: _getErrorMessage(
            statusCode,
            responseData,
          ),
        );

      case DioExceptionType.connectionError:
        return DioExceptions(
          message: "No Internet connection. Please check your connection.",
        );

      case DioExceptionType.badCertificate:
        return DioExceptions(
          message: "Bad SSL certificate.",
        );

      case DioExceptionType.unknown:
        return DioExceptions(
          message: "Unexpected error occurred.",
        );
    }
  }

  static String _getErrorMessage(
    int? statusCode,
    dynamic data,
  ) {
    // Laravel returned a JSON object
    if (data is Map<String, dynamic>) {
      final message = data['message'];

      // Example:
      // {
      //   "message": "Invalid credentials"
      // }
      if (message is String && message.isNotEmpty) {
        return message;
      }

      // Handle Laravel validation errors
      // Example:
      // {
      //   "message": "The given data was invalid.",
      //   "errors": {
      //     "email": [
      //       "The email field is required."
      //     ]
      //   }
      // }
      final errors = data['errors'];

      if (errors is Map) {
        for (final error in errors.values) {
          if (error is List && error.isNotEmpty) {
            return error.first.toString();
          }

          if (error is String && error.isNotEmpty) {
            return error;
          }
        }
      }
    }

    // Fallback based on HTTP status code
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your request and try again.';

      case 401:
        return 'Invalid login credentials.';

      case 403:
        return 'Access to this resource is forbidden.';

      case 404:
        return 'The resource you requested was not found.';

      case 409:
        return 'A conflict occurred. Please try again.';

      case 422:
        return 'Please check the information you provided.';

      case 500:
        return 'There was an internal server error.';

      case 502:
        return 'The server received an invalid response.';

      default:
        return 'Unexpected error. Status code: $statusCode';
    }
  }

  @override
  String toString() => message;
}