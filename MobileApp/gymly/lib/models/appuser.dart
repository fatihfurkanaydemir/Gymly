enum UserType { normal, trainer }

class AppUser {
  final double weight;
  final double height;
  final String gender;
  final DateTime dateOfBirth;
  final UserType userType;

  AppUser(
    this.weight,
    this.height,
    this.userType,
    this.gender,
    this.dateOfBirth,
  );

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      json['weight'] as double,
      json["height"] as double,
      json["userType"] as UserType,
      json["gender"] as String,
      json["dateOfBirth"] as DateTime,
    );
  }
}
