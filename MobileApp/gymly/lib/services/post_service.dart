import 'dart:convert';
import 'dart:io';

import 'package:gymly/models/post_interaction.dart';
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

import '../models/trainer_news.dart';

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

  Future<List<TrainerNews>> getTrainerNews({
    required String subjectId,
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final response = await client.get(Uri.parse(
          "${serviceUrl!}/TrainerNews?subjectId=$subjectId&pageNumber=$pageNumber&pageSize=$pageSize"));
      final data = json.decode(response.body) as Map<String, dynamic>;

      List<TrainerNews> news = [];
      for (var newsJson in (data["data"] as List<dynamic>)) {
        news.add(TrainerNews.fromJson(newsJson as Map<String, dynamic>));
      }

      return news;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> createTrainerNews({
    required String title,
    required String content,
  }) async {
    try {
      final response = await client.post(
        Uri.parse("${serviceUrl!}/TrainerNews"),
        body: json.encode({
          "title": title,
          "content": content,
        }),
        headers: {"Content-Type": "application/json"},
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      return data["succeeded"] as bool;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> deleteTrainerNews({
    required String id,
  }) async {
    try {
      final response = await client.delete(
        Uri.parse("${serviceUrl!}/TrainerNews"),
        body: json.encode({
          "id": id,
        }),
        headers: {"Content-Type": "application/json"},
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      return data["succeeded"] as bool;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> deletePost({
    required String id,
  }) async {
    try {
      final response = await client.delete(
        Uri.parse("${serviceUrl!}/Post"),
        body: json.encode({
          "id": id,
        }),
        headers: {"Content-Type": "application/json"},
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      return data["succeeded"] as bool;
    } catch (_) {
      rethrow;
    }
  }

  Future<Post> getPostById(
    String postId,
  ) async {
    try {
      final response = await client
          .get(Uri.parse("${serviceUrl!}/Post/GetPostById?PostId=$postId"));
      final data = json.decode(response.body) as Map<String, dynamic>;

      return Post.fromJson(data["data"] as Map<String, dynamic>);
    } catch (_) {
      rethrow;
    }
  }

  Future<List<PostInteraction>> getPostInteractions() async {
    try {
      final response =
          await client.get(Uri.parse("${serviceUrl!}/PostInteraction"));
      final data = json.decode(response.body) as Map<String, dynamic>;

      final interactionData = data["data"] as List<dynamic>;
      List<PostInteraction> interactions = [];

      for (dynamic interaction in interactionData) {
        interactions.add(PostInteraction.fromJson(interaction));
      }

      return interactions;
    } catch (_) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> interactWithPost(
      PostInteraction interaction) async {
    try {
      final response = await client.post(
        Uri.parse("$serviceUrl/PostInteraction"),
        body: json.encode(interaction.toJson()),
        headers: {"Content-Type": "application/json"},
      );

      final data = json.decode(response.body) as Map<String, dynamic>;
      return data;
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

      return true;
    } catch (_) {
      rethrow;
    }
  }
}
