import 'package:dio/dio.dart';

class DioExceptionHandler {
  static Map<String, dynamic> handle(DioException e) {
    String message = "Something went wrong";

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout. Server took too long to respond.";
        break;

      case DioExceptionType.sendTimeout:
        message = "Send timeout. Failed to send request in time.";
        break;

      case DioExceptionType.receiveTimeout:
        message = "Receive timeout. Server is not responding.";
        break;

      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        final data = e.response?.data;

        if (status == 422 && data is Map && data['errors'] != null) {
          // Extract first error message dynamically
          final errors = data['errors'] as Map<String, dynamic>;
          message = errors.values.first[0];
        } else {
          message = data?['message'] ?? "Server returned an error ($status)";
        }
        break;

      case DioExceptionType.cancel:
        message = "Request cancelled.";
        break;

      case DioExceptionType.connectionError:
        message = "Network error. Check your internet connection.";
        break;

      case DioExceptionType.unknown:
        message = "Unexpected error occurred.";
        break;
      case DioExceptionType.badCertificate:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    return {"success": false, "message": message};
  }
}
