import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gymly/interceptors/auth_interceptor.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/models/post.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PostService {
  Client client;
  static final serviceUrl = dotenv.env['POST_SERVICE_URL'];

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
      print("LOG: ${response.body}");
      List<Post> posts = [];

      for (dynamic post in postData) {
        posts.add(Post.fromJson(post));
      }

      return posts;
    } catch (_) {
      rethrow;
    }
  }
}
