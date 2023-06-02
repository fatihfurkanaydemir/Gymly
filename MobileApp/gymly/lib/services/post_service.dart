import 'dart:convert';
import 'dart:io';

import 'package:gymly/models/upload_post.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gymly/interceptors/auth_interceptor.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/models/post.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';

class PostService {
  Client client;
  static final serviceUrl = dotenv.env['POST_SERVICE_URL'];
  static final resourceServiceUrl = dotenv.env['RESOURCE_SERVICE_URL'];

  PostService(Authentication authentication,
      AuthenticationNotifier authNotifier, FlutterSecureStorage storage)
      : client = InterceptedClient.build(
          interceptors: [
            AuthInterceptor(
                authentication: authNotifier.state, storage: storage),
          ],
          retryPolicy: ExpiredTokenRetryPolicy(authNotifier),
        );

  Future<List<Post>> getPosts({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final response = await client.get(Uri.parse(
          "${serviceUrl!}/Post?pageNumber=$pageNumber&pageSize=$pageSize"));
      final data = json.decode(response.body) as Map<String, dynamic>;
      final postData = data["data"] as List<dynamic>;
      List<Post> posts = [];

      for (dynamic post in postData) {
        posts.add(Post.fromJson(post));
      }

      return posts;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<Post>> getUserPosts({
    required String subjectId,
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final response = await client.get(Uri.parse(
          "${serviceUrl!}/Post/GetUserPosts?subjectId=$subjectId&pageNumber=$pageNumber&pageSize=$pageSize"));
      final data = json.decode(response.body) as Map<String, dynamic>;
      final postData = data["data"] as List<dynamic>;
      List<Post> posts = [];

      for (dynamic post in postData) {
        posts.add(Post.fromJson(post));
      }

      return posts;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> uploadPost({
    required List<File> images,
    required String content,
  }) async {
    try {
      var fileUploadRequest = http.MultipartRequest(
          "POST", Uri.parse("${resourceServiceUrl!}/Resource/UploadImages"));
      List<Future<MultipartFile>> filesToUploadFutures = [];
      images.forEach((element) {
        filesToUploadFutures.add(
          http.MultipartFile.fromPath(
            'picture',
            element.path,
            filename: element.path.split("/").last,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      });

      List<MultipartFile> filesToUpload =
          await Future.wait(filesToUploadFutures);

      fileUploadRequest.files.addAll(filesToUpload);
      final fileUploadResponse =
          await http.Response.fromStream(await client.send(fileUploadRequest));

      final List<String> fileUrls = [];
      ((json.decode(fileUploadResponse.body) as Map<String, dynamic>)["data"])
          .forEach((e) => fileUrls.add(e as String));

      final postData = UploadPostModel(fileUrls, content);
      final postResponse = await client.post(
        Uri.parse("$serviceUrl/Post"),
        body: json.encode(postData.toJson()),
        headers: {"Content-Type": "application/json"},
      );

      print("LOG: ${postResponse.body}");

      return true;
    } catch (_) {
      rethrow;
    }
  }
}
