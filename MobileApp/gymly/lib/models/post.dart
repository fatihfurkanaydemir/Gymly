class Post {
  final String id;
  final DateTime createDate;
  final String subjectId;
  final List<String> imageUrls;
  final String content;
  final int amazedCount;
  final int celebrationCount;
  final int reachedTargetCount;
  final int flameCount;
  final int lostMindCount;

  Post(
      this.id,
      this.createDate,
      this.subjectId,
      this.imageUrls,
      this.content,
      this.amazedCount,
      this.celebrationCount,
      this.reachedTargetCount,
      this.flameCount,
      this.lostMindCount);

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      json['id'] as String,
      DateTime.parse(json["createDate"]),
      json["subjectId"] as String,
      (json["imageUrls"] as List<dynamic>).map((e) => e as String).toList(),
      json["content"] as String,
      json["amazedCount"] as int,
      json["celebrationCount"] as int,
      json["reachedTargetCount"] as int,
      json["flameCount"] as int,
      json["lostMindCount"] as int,
    );
  }
}
