import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/models/trainer.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/storage_provider.dart';
import 'package:gymly/services/user_service.dart';

import '../models/workout.dart';

class UserState {
  final AppUser? user;

  const UserState({this.user});

  UserState copyWith({AppUser? user}) {
    return UserState(user: user);
  }
}

class UserStateNotifier extends StateNotifier<UserState> {
  UserService userService;
  UserStateNotifier(this.userService) : super(const UserState()) {
    getUser();
  }

  Future<void> getUser() async {
    AppUser user = await userService.getUser();
    state = UserState(user: user);
  }

  Future<bool> updateMeasurements(double weight, double height) async {
    return await userService.updateMeasurements(weight, height);
  }

  Future<bool> addUserWorkoutProgram(
      String title, String description, String content) async {
    return await userService.addUserWorkoutProgram(title, description, content);
  }

  Future<bool> updateUserWorkoutProgram(
      int id, String title, String description, String content) async {
    return await userService.updateUserWorkoutProgram(
        id, title, description, content);
  }

  Future<bool> deleteUserWorkoutProgram(int id) async {
    return await userService.deleteUserWorkoutProgram(id);
  }

  Future<bool> updateDiet(String diet) async {
    return await userService.updateDiet(diet);
  }

  Future<List<Workout>> getWorkoutHistory() async {
    return await userService.getWorkoutHistory(pageNumber: 1, pageSize: 100);
  }

  Future<bool> createWorkout(
      int durationInMinutes, int userWorkoutProgramId) async {
    return await userService.createWorkout(
        durationInMinutes, userWorkoutProgramId);
  }

  Future<bool> deleteWorkout(int id) async {
    return await userService.deleteWorkout(id);
  }

  Future<bool> addTrainerWorkoutProgram(
    File image,
    String name,
    String title,
    String description,
    String programDetails,
    double price,
  ) async {
    bool success = await userService.addTrainerWorkoutProgram(
        image, name, title, description, programDetails, price);
    await getUser();
    return success;
  }

  Future<bool> deleteTrainerWorkoutProgram(int id) async {
    return await userService.deleteTrainerWorkoutProgram(id);
  }

  Future<bool> switchToTrainerAccountType() async {
    bool success = await userService.switchToTrainerAccountType();
    await getUser();

    return success;
  }
}

final userProvider = StateNotifierProvider<UserStateNotifier, UserState>(
    (ref) => UserStateNotifier(UserService(
          ref.watch(authProvider),
          ref.watch(authProvider.notifier),
          ref.watch(storageProvider),
        )));
