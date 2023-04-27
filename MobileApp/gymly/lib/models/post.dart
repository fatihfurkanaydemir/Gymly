class Post {
  final String id;
  final DateTime createDate;
  final String subjectId;
  final String imageUrl;
  final String content;
  final int likeCount;

  Post(
    this.id,
    this.createDate,
    this.subjectId,
    this.imageUrl,
    this.content,
    this.likeCount,
  );

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      json['id'] as String,
      DateTime.parse(json["createDate"]),
      json["subjectId"] as String,
      json["imageUrl"] as String,
      json["content"] as String,
      json["likeCount"] as int,
    );
  }
}
