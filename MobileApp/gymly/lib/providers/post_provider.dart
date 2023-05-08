import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/storage_provider.dart';
import 'package:gymly/services/post_service.dart';

import '../models/post.dart';

class PostState {
  static const int pageSize = 5;

  final List<Post>? posts;
  final bool? isFirstFetch;
  final int? pageNumber;
  final bool? canFetchMore;

  const PostState(
      {this.posts,
      this.pageNumber = 1,
      this.isFirstFetch = true,
      this.canFetchMore = true});

  PostState copyWith({
    List<Post>? posts,
    int? pageNumber,
    bool? isFirstFetch,
    bool? canFetchMore,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      pageNumber: pageNumber ?? this.pageNumber,
      isFirstFetch: isFirstFetch ?? this.isFirstFetch,
      canFetchMore: canFetchMore ?? this.canFetchMore,
    );
  }
}

class PostStateNotifier extends StateNotifier<PostState> {
  PostService postService;
  PostStateNotifier(this.postService) : super(const PostState());

  Future<void> getPosts() async {
    List<Post> posts = await postService.getPosts(
        pageNumber: state.pageNumber!, pageSize: PostState.pageSize);

    state = state.copyWith(
        posts: [...state.posts ?? [], ...posts],
        pageNumber: state.pageNumber! + 1,
        isFirstFetch: false,
        canFetchMore: posts.length >= PostState.pageSize);
  }

  Future<void> refreshPosts() async {
    state = const PostState(posts: [], isFirstFetch: false);

    await getPosts();
  }
}

final postProvider = StateNotifierProvider<PostStateNotifier, PostState>(
    (ref) => PostStateNotifier(
          PostService(
            ref.watch(authProvider),
            ref.watch(authProvider.notifier),
            ref.watch(storageProvider),
          ),
        ));
