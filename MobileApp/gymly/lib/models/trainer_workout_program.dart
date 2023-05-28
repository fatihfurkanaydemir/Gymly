class TrainerWorkoutProgram {
  final int id;
  final String name;
  final String title;
  final String description;
  final String headerImageUrl;
  final String programDetails;
  final double price;

  TrainerWorkoutProgram(this.id, this.name, this.title, this.description,
      this.headerImageUrl, this.programDetails, this.price);

  factory TrainerWorkoutProgram.fromJson(Map<String, dynamic> json) {
    return TrainerWorkoutProgram(
      json["id"] as int,
      json["name"] as String,
      json["title"] as String,
      json["description"] as String,
      json["headerImageUrl"] as String,
      json["programDetails"] as String,
      double.tryParse(json["price"].toString())!,
    );
  }
}
