class TrainerNews {
  final String id;
  final DateTime createDate;
  final String subjectId;
  final String title;
  final String content;

  TrainerNews(
    this.id,
    this.createDate,
    this.subjectId,
    this.title,
    this.content,
  );

  factory TrainerNews.fromJson(Map<String, dynamic> json) {
    return TrainerNews(
      json["id"] as String,
      DateTime.parse(json["createDate"]),
      json["subjectId"] as String,
      json["title"] as String,
      json["content"] as String,
    );
  }
}
