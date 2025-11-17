// import 'package:dio/dio.dart';
// import 'package:horizonpay/network/dio_exception.dart';
// import 'package:horizonpay/network/service_api.dart';

// class ApiClient {
//   late Dio _dio;
//   ApiClient() {
//     _dio = Dio(BaseOptions(
//         baseUrl: ServicesApi.baseURL,
//         connectTimeout: Duration(seconds: 10),
//         receiveTimeout: Duration(seconds: 10),
//         headers: {
//           'Content-type': 'application/json',
//           'Accept': 'application/json'
//         }));
//   }

//   Future<Response> fetchTerminals(int page) async {
//     try {
//       final response = await _dio
//           .get(ServicesApi.getAllTerminalURL, queryParameters: {'page': page});
//       return response;
//     } on DioException catch (dioError) {
//       throw DioExceptions.fromDioError(dioError);
//     }
//   }
// }
