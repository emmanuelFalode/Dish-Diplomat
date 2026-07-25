class LoginModel {
  final String email;
  final String password;

  LoginModel({required this.email, required this.password});

  Map<dynamic, String> toJson() {
    return {'email': email, 'password': password};
  }
}
