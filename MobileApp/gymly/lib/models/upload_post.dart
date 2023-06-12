class UploadPostModel {
  List<String> imageUrls;
  String content;

  UploadPostModel(this.imageUrls, this.content);

  Map<String, dynamic> toJson() {
    return {"imageUrls": imageUrls, "content": content};
  }
}
