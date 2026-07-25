import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/models/login_model.dart';
import 'package:foodapp/models/login_response_model.dart';
import 'package:foodapp/providers/dio_exception.dart';
import 'package:foodapp/providers/dish_api.dart';
import 'package:foodapp/services/token_storage.dart';

class AuthSate {
  final bool isLoading;
  final LoginResponseModel? loginResponse;
  final String? token;
  final String? errorMessage;

  AuthSate({
    this.isLoading = false,
    this.loginResponse,
    this.token,
    this.errorMessage,
  });
}

class AuthNotifier extends Notifier<AuthSate> {
  @override
  AuthSate build() {
    return AuthSate();
  }

  Future<void> login(LoginModel loginModel) async {
    state = AuthSate(isLoading: true);

    try {
      final result = await ApiService.login(loginModel);

      await TokenStorage.saveToken(result.token);

      state = AuthSate(isLoading: false, loginResponse: result, token: result.token);
   
    } on DioExceptions catch (e) {
      state = AuthSate(isLoading: false, errorMessage: e.message);
    }
  }

  Future<void> logout() async{
    await TokenStorage.deleteToken();
    state = AuthSate();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthSate>(AuthNotifier.new);
