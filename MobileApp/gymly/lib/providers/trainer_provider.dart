import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/trainer.dart';
import 'package:gymly/providers/storage_provider.dart';
import 'package:gymly/services/user_service.dart';

import '../services/trainer_service.dart';
import 'auth_provider.dart';

class TrainerProviderState {
  static const int pageSize = 15;

  final List<Trainer>? trainers;
  final bool? isFirstFetch;
  final int? pageNumber;
  final bool? canFetchMore;

  const TrainerProviderState({
    this.trainers,
    this.pageNumber = 1,
    this.isFirstFetch = true,
    this.canFetchMore = true,
  });

  TrainerProviderState copyWith({
    List<Trainer>? trainers,
    int? pageNumber,
    bool? isFirstFetch,
    bool? canFetchMore,
  }) {
    return TrainerProviderState(
      trainers: trainers ?? this.trainers,
      pageNumber: pageNumber ?? this.pageNumber,
      isFirstFetch: isFirstFetch ?? this.isFirstFetch,
      canFetchMore: canFetchMore ?? this.canFetchMore,
    );
  }
}

class TrainerProviderStateNotifier extends StateNotifier<TrainerProviderState> {
  TrainerService trainerService;
  TrainerProviderStateNotifier(this.trainerService)
      : super(const TrainerProviderState());

  Future<void> getTrainers() async {
    List<Trainer> trainers = await trainerService.getTrainers(
        pageNumber: state.pageNumber!, pageSize: TrainerProviderState.pageSize);

    state = state.copyWith(
        trainers: [...state.trainers ?? [], ...trainers],
        pageNumber: state.pageNumber! + 1,
        isFirstFetch: false,
        canFetchMore: trainers.length >= TrainerProviderState.pageSize);
  }

  Future<void> refreshTrainers() async {
    state = const TrainerProviderState(trainers: [], isFirstFetch: false);

    await getTrainers();
  }

  Future<Trainer> getTrainerBySubjectId(String subjectId) async {
    return await trainerService.getTrainerBySubjectId(subjectId);
  }
}

final trainerProvider =
    StateNotifierProvider<TrainerProviderStateNotifier, TrainerProviderState>(
        (ref) => TrainerProviderStateNotifier(
              TrainerService(
                ref.watch(authProvider),
                ref.watch(authProvider.notifier),
                ref.watch(storageProvider),
              ),
            ));
