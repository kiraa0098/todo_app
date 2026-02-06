class AccountUserModel {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? suffix;
  final DateTime? birthday;

  AccountUserModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.suffix,
    this.birthday,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'suffix': suffix,
      'birthday': birthday?.toIso8601String(),
    };
  }
}
