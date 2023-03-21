class AuthUser {
  String sub;
  String name;
  String email;

  AuthUser({required this.sub, required this.name, required this.email});

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      sub: json['sub'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}
