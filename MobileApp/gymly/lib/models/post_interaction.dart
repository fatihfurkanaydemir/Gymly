class PostInteraction {
  String id;
  final String subjectId;
  final String postId;
  final bool amazed;
  final bool celebration;
  final bool reachedTarget;
  final bool flame;
  final bool lostMind;

  PostInteraction(
    this.id,
    this.subjectId,
    this.postId,
    this.amazed,
    this.celebration,
    this.reachedTarget,
    this.flame,
    this.lostMind,
  );

  factory PostInteraction.fromJson(Map<String, dynamic> json) {
    return PostInteraction(
      json['id'] as String,
      json["subjectId"] as String,
      json["postId"] as String,
      json["amazed"] as bool,
      json["celebration"] as bool,
      json["reachedTarget"] as bool,
      json["flame"] as bool,
      json["lostMind"] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subjectId": subjectId,
      "postId": postId,
      "amazed": amazed,
      "celebration": celebration,
      "reachedTarget": reachedTarget,
      "flame": flame,
      "lostMind": lostMind,
    };
  }

  PostInteraction copyWith({
    String? id,
    String? subjectId,
    String? postId,
    bool? amazed,
    bool? celebration,
    bool? reachedTarget,
    bool? flame,
    bool? lostMind,
  }) {
    return PostInteraction(
      id ?? this.id,
      subjectId ?? this.subjectId,
      postId ?? this.postId,
      amazed ?? this.amazed,
      celebration ?? this.celebration,
      reachedTarget ?? this.reachedTarget,
      flame ?? this.flame,
      lostMind ?? this.lostMind,
    );
  }
}
