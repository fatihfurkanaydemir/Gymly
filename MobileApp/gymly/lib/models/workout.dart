class Workout {
  final String subjectId;
  final int id;
  final DateTime created;
  final int durationInMinutes;
  final String programTitle;
  final String programDescription;
  final String programContent;

  Workout(
    this.subjectId,
    this.id,
    this.created,
    this.durationInMinutes,
    this.programTitle,
    this.programDescription,
    this.programContent,
  );

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      json['subjectId'] as String,
      json['id'] as int,
      DateTime.parse(json["createDate"]),
      json["durationInMinutes"] as int,
      json["programTitle"] as String,
      json["programDescription"] as String,
      json["programContent"] as String,
    );
  }
}
