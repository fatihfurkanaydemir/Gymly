import 'dart:convert';
import 'dart:io';

import 'package:gymly/models/chat_message.dart';
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

class ChatService {
  Client client;
  static final serviceUrl = dotenv.env['CHAT_SERVICE_URL'];

  ChatService(Authentication authentication,
      AuthenticationNotifier authNotifier, FlutterSecureStorage storage)
      : client = InterceptedClient.build(
          interceptors: [
            AuthInterceptor(
                authentication: authNotifier.state, storage: storage),
          ],
          retryPolicy: ExpiredTokenRetryPolicy(authNotifier),
        );

  Future<List<ChatMessage>> getChatHistory({
    required String otherUserId,
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final response = await client.get(Uri.parse(
          "${serviceUrl!}/ChatHistory?otherUserId=$otherUserId&pageNumber=$pageNumber&pageSize=$pageSize"));
      final data = json.decode(response.body) as Map<String, dynamic>;

      List<ChatMessage> messages = [];
      for (var msgJson in (data["data"] as List<dynamic>)) {
        messages.add(ChatMessage.fromJson(msgJson as Map<String, dynamic>));
      }

      return messages;
    } catch (_) {
      rethrow;
    }
  }
}
