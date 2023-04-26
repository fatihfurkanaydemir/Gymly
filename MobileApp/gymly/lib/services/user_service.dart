import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gymly/interceptors/auth_interceptor.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
  Client client;
  static final serviceUrl = dotenv.env['USER_SERVICE_URL'];

  UserService(Authentication authentication,
      AuthenticationNotifier authNotifier, FlutterSecureStorage storage)
      : client = InterceptedClient.build(
          interceptors: [
            AuthInterceptor(
                authentication: authNotifier.state, storage: storage),
          ],
          retryPolicy: ExpiredTokenRetryPolicy(authNotifier),
        );

  Future<AppUser> getUser() async {
    try {
      final response = await client.get(Uri.parse("${serviceUrl!}/User"));
      final data = json.decode(response.body) as Map<String, dynamic>;
      print("LOG: ${response.body}");

      return AppUser(
          0, 0, UserType.regular, "", DateTime.now()); //AppUser.fromJson(data);
    } catch (_) {
      rethrow;
    }
  }
}
