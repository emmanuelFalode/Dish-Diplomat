class Dishmodel {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;

  Dishmodel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  // Convert to map for Dio
  Map<String, dynamic> toMap() {
    return {
      'action': 'register',
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'password': password,
    };
  }

  // Optionally add a factory if you're handling response parsing later
  factory Dishmodel.fromMap(Map<String, dynamic> map) {
    return Dishmodel(
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
