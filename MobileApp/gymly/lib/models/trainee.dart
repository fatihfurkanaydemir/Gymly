import 'package:gymly/models/trainer_workout_program.dart';

class Trainee {
  final int id;
  final String subjectId;
  final double weight;
  final double height;
  final String gender;
  final String diet;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final TrainerWorkoutProgram? enrolledProgram;

  Trainee(
    this.id,
    this.subjectId,
    this.weight,
    this.height,
    this.gender,
    this.diet,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.enrolledProgram,
  );

  factory Trainee.fromJson(Map<String, dynamic> json) {
    TrainerWorkoutProgram? enrolledProgram;
    if (json["enrolledProgram"] != null) {
      enrolledProgram = TrainerWorkoutProgram.fromJson(json["enrolledProgram"]);
    }

    return Trainee(
      json["id"] as int,
      json["subjectId"] as String,
      double.parse(json['weight'].toString()),
      double.parse(json["height"].toString()),
      json["gender"] as String,
      json["diet"] as String,
      json["firstName"] as String,
      json["lastName"] as String,
      json["avatarUrl"] as String,
      enrolledProgram,
    );
  }
}
