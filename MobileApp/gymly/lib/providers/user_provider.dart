import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/storage_provider.dart';
import 'package:gymly/services/user_service.dart';

class UserState {
  final AppUser? user;

  const UserState({this.user});

  UserState copyWith({AppUser? user}) {
    return UserState(user: user);
  }
}

class UserStateNotifier extends StateNotifier<UserState> {
  UserService userService;
  UserStateNotifier(this.userService) : super(const UserState());

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
}

final userProvider = StateNotifierProvider<UserStateNotifier, UserState>(
    (ref) => UserStateNotifier(UserService(
          ref.watch(authProvider),
          ref.watch(authProvider.notifier),
          ref.watch(storageProvider),
        )));
