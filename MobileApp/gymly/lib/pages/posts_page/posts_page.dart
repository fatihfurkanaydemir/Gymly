import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/auth_user.dart';
import 'package:gymly/models/post_interaction.dart';
import 'package:gymly/pages/posts_page/post_card.dart';
import 'package:gymly/pages/unknown_route_page.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/post_provider.dart';

import '../../models/post.dart';

class PostsPage extends ConsumerStatefulWidget {
  static const routeName = "/PostsPage";

  const PostsPage({super.key});

  @override
  PostsPageState createState() => PostsPageState();
}

class PostsPageState extends ConsumerState<PostsPage> {
  bool hasListener = false;
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Post>? posts = ref.watch(postProvider).posts;
    List<PostInteraction>? interactions =
        ref.watch(postProvider).postInteractions;
    AuthUser? auth = ref.watch(authProvider).user;
    bool firstFetch = ref.watch(postProvider).isFirstFetch ?? true;
    bool canFetchMore = ref.watch(postProvider).canFetchMore ?? true;

    void fetch() {
      ref.read(postProvider.notifier).getPosts();
    }

    if (!hasListener) {
      controller.addListener(() {
        if (controller.position.maxScrollExtent == controller.offset) {
          fetch();
        }
      });
      setState(() {
        hasListener = true;
      });
    }

    if (firstFetch) {
      fetch();
    }

    if (posts == null || interactions == null || auth == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(postProvider.notifier).refreshPosts();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        cacheExtent: 5000,
        controller: controller,
        addAutomaticKeepAlives: true,
        itemBuilder: (ctx, index) {
          if (index < posts.length) {
            return PostCard(
              post: posts[index],
              interaction: interactions.firstWhere(
                  (element) => element.postId == posts[index].id,
                  orElse: () => PostInteraction("", auth.sub, posts[index].id,
                      false, false, false, false, false)),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: canFetchMore
                    ? const CircularProgressIndicator()
                    : const Text("End of the posts"),
              ),
            );
          }
        },
        itemCount: posts.length + 1,
      ),
    );
  }
}
