import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/storage_provider.dart';
import 'package:gymly/services/post_service.dart';

import '../models/post.dart';

class UserPostsState {
  static const int pageSize = 5;

  final List<Post>? posts;
  final bool? isFirstFetch;
  final int? pageNumber;
  final bool? canFetchMore;

  const UserPostsState({
    this.posts,
    this.pageNumber = 1,
    this.isFirstFetch = true,
    this.canFetchMore = true,
  });

  UserPostsState copyWith({
    List<Post>? posts,
    int? pageNumber,
    bool? isFirstFetch,
    bool? canFetchMore,
  }) {
    return UserPostsState(
      posts: posts ?? this.posts,
      pageNumber: pageNumber ?? this.pageNumber,
      isFirstFetch: isFirstFetch ?? this.isFirstFetch,
      canFetchMore: canFetchMore ?? this.canFetchMore,
    );
  }
}

class UserPostsStateNotifier extends StateNotifier<UserPostsState> {
  PostService postService;
  UserPostsStateNotifier(this.postService) : super(const UserPostsState());

  Future<void> getPosts(String subjectId) async {
    List<Post> posts = await postService.getUserPosts(
      subjectId: subjectId,
      pageNumber: state.pageNumber!,
      pageSize: UserPostsState.pageSize,
    );

    state = state.copyWith(
      posts: [...state.posts ?? [], ...posts],
      pageNumber: state.pageNumber! + 1,
      isFirstFetch: false,
      canFetchMore: posts.length >= UserPostsState.pageSize,
    );
  }

  Future<void> refreshPosts(String subjectId) async {
    state = const UserPostsState(posts: [], isFirstFetch: false);

    await getPosts(subjectId);
  }
}

final userPostsProvider =
    StateNotifierProvider<UserPostsStateNotifier, UserPostsState>(
        (ref) => UserPostsStateNotifier(
              PostService(
                ref.watch(authProvider),
                ref.watch(authProvider.notifier),
                ref.watch(storageProvider),
              ),
            ));
