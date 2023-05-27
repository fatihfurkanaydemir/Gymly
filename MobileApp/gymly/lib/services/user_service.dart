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

      return AppUser.fromJson(data["data"] as Map<String, dynamic>);
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> updateMeasurements(double weight, double height) async {
    try {
      final response = await client.patch(
        Uri.parse("${serviceUrl!}/User/UpdateMeasurements"),
        body:
            json.encode({"subjectId": "", "weight": weight, "height": height}),
        headers: {"Content-Type": "application/json"},
      );

      final data = json.decode(response.body) as Map<String, dynamic>;
      return data["succeeded"] as bool;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> addUserWorkoutProgram(
      String title, String description, String content) async {
    try {
      final response = await client.post(
        Uri.parse("${serviceUrl!}/WorkoutProgram/CreateUserWorkoutProgram"),
        body: json.encode({
          "subjectId": "",
          "title": title,
          "description": description,
          "content": content
        }),
        headers: {"Content-Type": "application/json"},
      );

      final data = json.decode(response.body) as Map<String, dynamic>;
      return data["succeeded"] as bool;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> updateUserWorkoutProgram(
      int id, String title, String description, String content) async {
    try {
      final response = await client.patch(
        Uri.parse("${serviceUrl!}/WorkoutProgram/UpdateUserWorkoutProgram"),
        body: json.encode({
          "subjectId": "",
          "id": id,
          "title": title,
          "description": description,
          "content": content
        }),
        headers: {"Content-Type": "application/json"},
      );

      final data = json.decode(response.body) as Map<String, dynamic>;
      return data["succeeded"] as bool;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> deleteUserWorkoutProgram(int id) async {
    try {
      final response = await client.delete(
        Uri.parse("${serviceUrl!}/WorkoutProgram/DeleteUserWorkoutProgram"),
        body: json.encode({
          "subjectId": "",
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
}
