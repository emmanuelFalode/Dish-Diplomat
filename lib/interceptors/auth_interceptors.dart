import 'package:dio/dio.dart';
import 'package:foodapp/services/token_storage.dart';

class AuthInterceptors extends Interceptor{
  @override 
Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
 final token = await TokenStorage.getToken();

 if(token != null && token.isNotEmpty){
  options.headers['Authorization'] = 'Bearer $token';
 }

 handler.next(options);
}
}