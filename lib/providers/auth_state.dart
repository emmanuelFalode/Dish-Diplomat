import 'package:foodapp/models/login_response_model.dart';

class AuthState {
  final bool isLoading;
  final LoginResponseModel? loginResponseModel;
  final String? token;
  final String? errorMessage;

  AuthState({
    this.isLoading = false,
    this.loginResponseModel,
    this.token,
    this.errorMessage,
  });
}
