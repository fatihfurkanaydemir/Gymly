import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/providers/storage_provider.dart';
import 'package:gymly/services/workout_service.dart';

import 'auth_provider.dart';

class WorkoutProviderState {
  const WorkoutProviderState();

  WorkoutProviderState copyWith() {
    return WorkoutProviderState();
  }
}

class WorkoutProviderStateNotifier extends StateNotifier<WorkoutProviderState> {
  WorkoutService workoutService;
  WorkoutProviderStateNotifier(this.workoutService)
      : super(const WorkoutProviderState());

  Future<bool> enrollUserToProgram(int programId) async {
    return await workoutService.enrollUserToProgram(programId);
  }

  Future<bool> cancelUserEnrollment() async {
    return await workoutService.cancelUserEnrollment();
  }
}

final workoutProvider =
    StateNotifierProvider<WorkoutProviderStateNotifier, WorkoutProviderState>(
  (ref) => WorkoutProviderStateNotifier(
    WorkoutService(
      ref.watch(authProvider),
      ref.watch(authProvider.notifier),
      ref.watch(storageProvider),
    ),
  ),
);
