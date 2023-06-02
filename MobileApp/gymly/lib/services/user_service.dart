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

import '../models/workout.dart';

class UserService {
  Client client;
  static final serviceUrl = dotenv.env['USER_SERVICE_URL'];
  static final resourceServiceUrl = dotenv.env['RESOURCE_SERVICE_URL'];

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

  Future<bool> updateDiet(String diet) async {
    try {
      final response = await client.patch(
        Uri.parse("${serviceUrl!}/User/UpdateDiet"),
        body: json.encode({"diet": diet}),
        headers: {"Content-Type": "application/json"},
      );

      final data = json.decode(response.body) as Map<String, dynamic>;
      return data["succeeded"] as bool;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<Workout>> getWorkoutHistory(
    String subjectId, {
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final response = await client.get(Uri.parse(
          "${serviceUrl!}/User/Workout?subjectId=$subjectId&pageNumber=$pageNumber&pageSize=$pageSize"));
      final data = json.decode(response.body) as Map<String, dynamic>;

      List<Workout> workouts = [];
      for (var workoutJson in (data["data"] as List<dynamic>)) {
        workouts.add(Workout.fromJson(workoutJson as Map<String, dynamic>));
      }

      return workouts;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> createWorkout(
      int durationInMinutes, int userWorkoutProgramId) async {
    try {
      final response = await client.post(
        Uri.parse("${serviceUrl!}/User/Workout"),
        body: json.encode({
          "durationInMinutes": durationInMinutes,
          "userWorkoutProgramId": userWorkoutProgramId
        }),
        headers: {"Content-Type": "application/json"},
      );

      final data = json.decode(response.body) as Map<String, dynamic>;
      return data["succeeded"] as bool;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> deleteWorkout(int id) async {
    try {
      final response = await client.delete(
        Uri.parse("${serviceUrl!}/User/Workout"),
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

  Future<bool> addTrainerWorkoutProgram(
    File image,
    String name,
    String title,
    String description,
    String programDetails,
    double price,
  ) async {
    try {
      var fileUploadRequest = http.MultipartRequest(
          "POST", Uri.parse("${resourceServiceUrl!}/Resource/UploadImages"));
      List<Future<MultipartFile>> filesToUploadFutures = [];
      filesToUploadFutures.add(
        http.MultipartFile.fromPath(
          'picture',
          image.path,
          filename: image.path.split("/").last,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      List<MultipartFile> filesToUpload =
          await Future.wait(filesToUploadFutures);

      fileUploadRequest.files.addAll(filesToUpload);
      final fileUploadResponse =
          await http.Response.fromStream(await client.send(fileUploadRequest));

      final List<String> fileUrls = [];
      ((json.decode(fileUploadResponse.body) as Map<String, dynamic>)["data"])
          .forEach((e) => fileUrls.add(e as String));

      final postResponse = await client.post(
        Uri.parse("$serviceUrl/WorkoutProgram/CreateTrainerWorkoutProgram"),
        body: json.encode({
          "subjectId": "",
          "name": name,
          "title": title,
          "description": description,
          "programDetails": programDetails,
          "headerImageUrl": fileUrls[0],
          "price": price
        }),
        headers: {"Content-Type": "application/json"},
      );

      print("LOG: ${postResponse.body}");

      return true;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> deleteTrainerWorkoutProgram(int id) async {
    try {
      final response = await client.delete(
        Uri.parse("${serviceUrl!}/WorkoutProgram/DeleteTrainerWorkoutProgram"),
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

  Future<bool> switchToTrainerAccountType() async {
    try {
      final response = await client.post(
        Uri.parse("${serviceUrl!}/User/SwitchToTrainerAccountType"),
        body: json.encode({
          "subjectId": "",
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
