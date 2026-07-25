import 'package:foodapp/models/user_model.dart';

class LoginResponseModel {
  final bool success;
  final String message;
  final String token;
  final UserModel user;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginResponseModel(
      success: json['success'],
      message: json['message'],
      token: json['token'],
      user: UserModel.fromJson(json['data']),
    );
  }
}