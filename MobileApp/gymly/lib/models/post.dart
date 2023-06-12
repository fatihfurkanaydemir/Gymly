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
  final PostUser user;

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
      this.lostMindCount,
      this.user);

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
      PostUser.fromJson(json["user"]),
    );
  }
}

class PostUser {
  final double weight;
  final double height;
  final String gender;
  final String avatarUrl;
  final String firstName;
  final String lastName;

  PostUser(this.weight, this.height, this.gender, this.avatarUrl,
      this.firstName, this.lastName);

  factory PostUser.fromJson(Map<String, dynamic> json) {
    return PostUser(
      double.parse(json["weight"].toString()),
      double.parse(json["height"].toString()),
      json["gender"] as String,
      json["avatarUrl"] as String,
      json["firstName"] as String,
      json["lastName"] as String,
    );
  }
}
