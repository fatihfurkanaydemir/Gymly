import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/storage_provider.dart';
import 'package:gymly/services/post_service.dart';
import 'package:http/http.dart';

import '../models/trainer_news.dart';

class TrainerNewsState {
  static const int pageSize = 20;

  final List<TrainerNews>? news;
  final bool? isFirstFetch;
  final int? pageNumber;
  final bool? canFetchMore;

  const TrainerNewsState({
    this.news,
    this.pageNumber = 1,
    this.isFirstFetch = true,
    this.canFetchMore = true,
  });

  TrainerNewsState copyWith({
    List<TrainerNews>? news,
    int? pageNumber,
    bool? isFirstFetch,
    bool? canFetchMore,
  }) {
    return TrainerNewsState(
      news: news ?? this.news,
      pageNumber: pageNumber ?? this.pageNumber,
      isFirstFetch: isFirstFetch ?? this.isFirstFetch,
      canFetchMore: canFetchMore ?? this.canFetchMore,
    );
  }
}

class TrainerNewsStateNotifier extends StateNotifier<TrainerNewsState> {
  PostService postService;
  TrainerNewsStateNotifier(this.postService) : super(const TrainerNewsState());

  Future<void> getTrainerNews(String subjectId) async {
    List<TrainerNews> news = await postService.getTrainerNews(
      subjectId: subjectId,
      pageNumber: state.pageNumber!,
      pageSize: TrainerNewsState.pageSize,
    );

    state = state.copyWith(
      news: [...state.news ?? [], ...news],
      pageNumber: state.pageNumber! + 1,
      isFirstFetch: false,
      canFetchMore: news.length >= TrainerNewsState.pageSize,
    );
  }

  Future<void> refreshTrainerNews(String subjectId) async {
    state = const TrainerNewsState(news: [], isFirstFetch: false);

    await getTrainerNews(subjectId);
  }

  Future<bool> createTrainerNews({
    required String title,
    required String content,
  }) {
    return postService.createTrainerNews(title: title, content: content);
  }

  Future<bool> deleteTrainerNews({
    required String id,
  }) {
    return postService.deleteTrainerNews(id: id);
  }
}

final trainerNewsProvider =
    StateNotifierProvider<TrainerNewsStateNotifier, TrainerNewsState>(
        (ref) => TrainerNewsStateNotifier(
              PostService(
                ref.watch(authProvider),
                ref.watch(authProvider.notifier),
                ref.watch(storageProvider),
              ),
            ));
