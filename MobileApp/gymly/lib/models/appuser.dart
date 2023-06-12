import 'package:gymly/models/trainer_workout_program.dart';
import 'package:gymly/models/user_workout_program.dart';

enum UserType { normal, trainer }

class AppUser {
  final double weight;
  final double height;
  final String gender;
  final String diet;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final DateTime dateOfBirth;
  final UserType userType;
  final List<UserWorkoutProgram> userWorkoutPrograms;
  final List<TrainerWorkoutProgram> trainerWorkoutPrograms;
  final TrainerWorkoutProgram? enrolledProgram;

  AppUser(
    this.weight,
    this.height,
    this.userType,
    this.gender,
    this.diet,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.dateOfBirth,
    this.userWorkoutPrograms,
    this.trainerWorkoutPrograms,
    this.enrolledProgram,
  );

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final userWorkoutPrograms = <UserWorkoutProgram>[];
    (json["userWorkoutPrograms"] as List<dynamic>).forEach((element) {
      userWorkoutPrograms
          .add(UserWorkoutProgram.fromJson(element as Map<String, dynamic>));
    });

    final trainerWorkoutPrograms = <TrainerWorkoutProgram>[];
    (json["trainerWorkoutPrograms"] as List<dynamic>).forEach((element) {
      trainerWorkoutPrograms
          .add(TrainerWorkoutProgram.fromJson(element as Map<String, dynamic>));
    });

    TrainerWorkoutProgram? enrolledProgram;
    if (json["enrolledProgram"] != null) {
      enrolledProgram = TrainerWorkoutProgram.fromJson(json["enrolledProgram"]);
    }

    return AppUser(
      double.parse(json['weight'].toString()),
      double.parse(json["height"].toString()),
      UserType.values[json["type"] as int],
      json["gender"] as String,
      json["diet"] as String,
      json["firstName"] as String,
      json["lastName"] as String,
      json["avatarUrl"] as String,
      // json["dateOfBirth"] as DateTime,
      DateTime.now(), // TODO change
      userWorkoutPrograms,
      trainerWorkoutPrograms,
      enrolledProgram,
    );
  }
}
