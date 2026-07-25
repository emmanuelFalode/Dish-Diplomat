class UserModel {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? emailVerifiedAt;
  final String phoneNumber;
  final String? address;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.emailVerifiedAt,
    required this.phoneNumber,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
