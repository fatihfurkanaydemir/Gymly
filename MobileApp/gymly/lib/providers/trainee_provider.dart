import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/trainer.dart';
import 'package:gymly/providers/storage_provider.dart';
import 'package:gymly/services/user_service.dart';

import '../models/trainee.dart';
import '../services/trainer_service.dart';
import 'auth_provider.dart';

class TraineeProviderState {
  static const int pageSize = 100;

  final List<Trainee>? trainees;
  final bool? isFirstFetch;
  final int? pageNumber;
  final bool? canFetchMore;

  const TraineeProviderState({
    this.trainees,
    this.pageNumber = 1,
    this.isFirstFetch = true,
    this.canFetchMore = true,
  });

  TraineeProviderState copyWith({
    List<Trainee>? trainees,
    int? pageNumber,
    bool? isFirstFetch,
    bool? canFetchMore,
  }) {
    return TraineeProviderState(
      trainees: trainees ?? this.trainees,
      pageNumber: pageNumber ?? this.pageNumber,
      isFirstFetch: isFirstFetch ?? this.isFirstFetch,
      canFetchMore: canFetchMore ?? this.canFetchMore,
    );
  }
}

class TraineeProviderStateNotifier extends StateNotifier<TraineeProviderState> {
  TrainerService trainerService;
  TraineeProviderStateNotifier(this.trainerService)
      : super(const TraineeProviderState());

  Future<void> getTrainees() async {
    List<Trainee> trainees = await trainerService.getTrainees();

    state = state.copyWith(
        trainees: [...state.trainees ?? [], ...trainees],
        pageNumber: state.pageNumber! + 1,
        isFirstFetch: false,
        canFetchMore: trainees.length >= TraineeProviderState.pageSize);
  }

  Future<void> refreshTrainees() async {
    state = const TraineeProviderState(trainees: [], isFirstFetch: false);

    await getTrainees();
  }
}

final traineeProvider =
    StateNotifierProvider<TraineeProviderStateNotifier, TraineeProviderState>(
        (ref) => TraineeProviderStateNotifier(
              TrainerService(
                ref.watch(authProvider),
                ref.watch(authProvider.notifier),
                ref.watch(storageProvider),
              ),
            ));
