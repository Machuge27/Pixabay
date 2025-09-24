class UserProfile {
  final String fullName;
  final String email;
  final String favoriteCategory;
  final String password;
  final String confirmPassword;

  UserProfile({
    required this.fullName,
    required this.email,
    required this.favoriteCategory,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'favoriteCategory': favoriteCategory,
      'password': password,
    };
  }
}