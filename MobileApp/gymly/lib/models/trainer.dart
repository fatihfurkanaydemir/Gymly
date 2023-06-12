import 'package:gymly/models/trainer_workout_program.dart';

class Trainer {
  final int id;
  final String subjectId;
  final double weight;
  final double height;
  final String gender;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final List<TrainerWorkoutProgram> trainerWorkoutPrograms;

  Trainer(
    this.id,
    this.subjectId,
    this.weight,
    this.height,
    this.gender,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.trainerWorkoutPrograms,
  );

  factory Trainer.fromJson(Map<String, dynamic> json) {
    final trainerWorkoutPrograms = <TrainerWorkoutProgram>[];
    (json["trainerWorkoutPrograms"] as List<dynamic>).forEach((element) {
      trainerWorkoutPrograms
          .add(TrainerWorkoutProgram.fromJson(element as Map<String, dynamic>));
    });

    return Trainer(
      json["id"] as int,
      json["subjectId"] as String,
      double.parse(json['weight'].toString()),
      double.parse(json["height"].toString()),
      json["gender"] as String,
      json["firstName"] as String,
      json["lastName"] as String,
      json["avatarUrl"] as String,
      trainerWorkoutPrograms,
    );
  }
}
