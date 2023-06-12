import 'dart:convert';
import 'dart:io';
import 'package:gymly/models/trainer.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gymly/interceptors/auth_interceptor.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';

class WorkoutService {
  Client client;
  static final serviceUrl = dotenv.env['USER_SERVICE_URL'];
  static final resourceServiceUrl = dotenv.env['RESOURCE_SERVICE_URL'];

  WorkoutService(Authentication authentication,
      AuthenticationNotifier authNotifier, FlutterSecureStorage storage)
      : client = InterceptedClient.build(
          interceptors: [
            AuthInterceptor(
                authentication: authNotifier.state, storage: storage),
          ],
          retryPolicy: ExpiredTokenRetryPolicy(authNotifier),
        );

  Future<bool> enrollUserToProgram(int programId) async {
    try {
      final response = await client.post(
          Uri.parse("${serviceUrl!}/WorkoutProgram/EnrollUserToProgram"),
          body: json.encode({"programId": programId}),
          headers: {"Content-Type": "application/json"});

      final data = json.decode(response.body) as Map<String, dynamic>;
      return data["succeeded"] as bool;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> cancelUserEnrollment() async {
    try {
      final response = await client.post(
          Uri.parse("${serviceUrl!}/WorkoutProgram/CancelUserEnrollment"),
          headers: {"Content-Type": "application/json"});

      final data = json.decode(response.body) as Map<String, dynamic>;
      return data["succeeded"] as bool;
    } catch (_) {
      rethrow;
    }
  }
}
