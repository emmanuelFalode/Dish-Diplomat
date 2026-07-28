import 'package:foodapp/models/login_model.dart';
import 'package:foodapp/models/login_response_model.dart';
import 'package:foodapp/providers/auth_state.dart';
import 'package:foodapp/providers/dio_exception.dart';
import 'package:foodapp/providers/dish_api.dart';
import 'package:foodapp/services/token_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return AuthState();
  }

  Future<void> login(LoginModel loginModel) async {
    //start loading
    state = AuthState(isLoading: true);
    try {
      final LoginResponseModel result = await ApiService.login(loginModel);
      await TokenStorage.saveToken(result.token);

      state = AuthState(
        isLoading: false,
        loginResponseModel: result,
        token: result.token,
      );
    } on DioExceptions catch (e) {
      state = AuthState(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = AuthState(isLoading: false, errorMessage: 'Unexpected Error: $e');
    }
  }

  Future<void> logOut() async {
    TokenStorage.deleteToken();
    state = AuthState();
  }
}
