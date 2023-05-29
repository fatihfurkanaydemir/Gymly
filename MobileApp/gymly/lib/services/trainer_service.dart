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

import '../models/trainee.dart';

class TrainerService {
  Client client;
  static final serviceUrl = dotenv.env['USER_SERVICE_URL'];
  static final resourceServiceUrl = dotenv.env['RESOURCE_SERVICE_URL'];

  TrainerService(Authentication authentication,
      AuthenticationNotifier authNotifier, FlutterSecureStorage storage)
      : client = InterceptedClient.build(
          interceptors: [
            AuthInterceptor(
                authentication: authNotifier.state, storage: storage),
          ],
          retryPolicy: ExpiredTokenRetryPolicy(authNotifier),
        );

  Future<List<Trainer>> getTrainers({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final response = await client.get(Uri.parse(
          "${serviceUrl!}/User/Trainer?pageNumber=$pageNumber&pageSize=$pageSize"));
      final data = json.decode(response.body) as Map<String, dynamic>;

      final trainerData = data["data"] as List<dynamic>;
      List<Trainer> trainers = [];

      for (dynamic trainer in trainerData) {
        trainers.add(Trainer.fromJson(trainer));
      }

      return trainers;
    } catch (_) {
      rethrow;
    }
  }

  Future<Trainer> getTrainerBySubjectId(String subjectId) async {
    try {
      final response =
          await client.get(Uri.parse("${serviceUrl!}/User/Trainer/$subjectId"));
      final data = json.decode(response.body) as Map<String, dynamic>;

      return Trainer.fromJson(data["data"] as Map<String, dynamic>);
    } catch (_) {
      rethrow;
    }
  }

  Future<Trainee> getTraineeBySubjectId(String subjectId) async {
    try {
      final response =
          await client.get(Uri.parse("${serviceUrl!}/User/Trainee/$subjectId"));
      final data = json.decode(response.body) as Map<String, dynamic>;

      return Trainee.fromJson(data["data"] as Map<String, dynamic>);
    } catch (_) {
      rethrow;
    }
  }

  Future<List<Trainee>> getTrainees() async {
    try {
      final response = await client
          .get(Uri.parse("${serviceUrl!}/User/Trainer/GetEnrolledUsers"));
      final data = json.decode(response.body) as Map<String, dynamic>;

      List<Trainee> trainees = [];
      for (var traineeJson in (data["data"] as List<dynamic>)) {
        trainees.add(Trainee.fromJson(traineeJson as Map<String, dynamic>));
      }

      return trainees;
    } catch (_) {
      rethrow;
    }
  }
}
