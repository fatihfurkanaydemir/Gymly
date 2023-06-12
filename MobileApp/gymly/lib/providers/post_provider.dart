import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/post_interaction.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/storage_provider.dart';
import 'package:gymly/services/post_service.dart';
import 'package:http/http.dart';

import '../models/post.dart';

class PostState {
  static const int pageSize = 5;

  final List<Post>? posts;
  final List<PostInteraction>? postInteractions;
  final bool? isFirstFetch;
  final int? pageNumber;
  final bool? canFetchMore;

  const PostState({
    this.posts,
    this.postInteractions,
    this.pageNumber = 1,
    this.isFirstFetch = true,
    this.canFetchMore = true,
  });

  PostState copyWith({
    List<Post>? posts,
    List<PostInteraction>? postInteractions,
    int? pageNumber,
    bool? isFirstFetch,
    bool? canFetchMore,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      postInteractions: postInteractions ?? this.postInteractions,
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

    List<PostInteraction> postInteractions =
        await postService.getPostInteractions();

    if (mounted) {
      state = state.copyWith(
        posts: [...state.posts ?? [], ...posts],
        postInteractions: postInteractions,
        pageNumber: state.pageNumber! + 1,
        isFirstFetch: false,
        canFetchMore: posts.length >= PostState.pageSize,
      );
    }
  }

  Future<Post> getPostById(String postId) async {
    return await postService.getPostById(postId);
  }

  Future<bool> interactWithPost(PostInteraction interaction) async {
    final result = await postService.interactWithPost(interaction);
    if (result["succeeded"] as bool && mounted) {
      final interactionId = result["data"] as String;
      final post = await postService.getPostById(interaction.postId);
      List<Post> oldPosts = state.posts!;

      oldPosts[oldPosts.indexWhere((element) => element.id == post.id)] = post;

      List<PostInteraction> oldInteractions = state.postInteractions!;
      int oldInteractionIdx =
          oldInteractions.indexWhere((element) => element.id == interaction.id);

      if (oldInteractionIdx != -1) {
        oldInteractions[oldInteractionIdx] = interaction;
      } else {
        interaction.id = interactionId;
        oldInteractions.add(interaction);
      }

      state =
          state.copyWith(posts: oldPosts, postInteractions: oldInteractions);
    }

    return result["succeeded"];
  }

  Future<void> refreshPosts() async {
    state =
        const PostState(posts: [], postInteractions: [], isFirstFetch: false);

    await getPosts();
  }

  Future<bool> uploadPost({
    required List<File> images,
    required String content,
  }) {
    return postService.uploadPost(images: images, content: content);
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
