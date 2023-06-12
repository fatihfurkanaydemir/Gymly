class UserWorkoutProgram {
  final int id;
  final String title;
  final String description;
  final String content;

  UserWorkoutProgram(
    this.id,
    this.title,
    this.description,
    this.content,
  );

  factory UserWorkoutProgram.fromJson(Map<String, dynamic> json) {
    return UserWorkoutProgram(
      json["id"] as int,
      json["title"] as String,
      json["description"] as String,
      json["content"] as String,
    );
  }
}
