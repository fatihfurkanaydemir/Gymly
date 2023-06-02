import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/pages/posts_page/post_card.dart';
import 'package:gymly/pages/unknown_route_page.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/post_provider.dart';
import 'package:gymly/providers/user_posts_provider.dart';

import '../../models/auth_user.dart';
import '../../models/post.dart';

class UserPostsTab extends ConsumerStatefulWidget {
  const UserPostsTab({super.key});

  @override
  UserPostsTabState createState() => UserPostsTabState();
}

class UserPostsTabState extends ConsumerState<UserPostsTab> {
  bool hasListener = false;
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthUser? user = ref.watch(authProvider).user;
    List<Post>? posts = ref.watch(userPostsProvider).posts;
    bool firstFetch = ref.watch(userPostsProvider).isFirstFetch ?? true;
    bool canFetchMore = ref.watch(userPostsProvider).canFetchMore ?? true;

    void fetch() {
      ref.read(userPostsProvider.notifier).getPosts(user?.sub ?? "");
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

    if (posts == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(userPostsProvider.notifier)
            .refreshPosts(user?.sub ?? "");
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        cacheExtent: 5000,
        controller: controller,
        itemBuilder: (ctx, index) {
          if (index < posts.length) {
            return PostCard(post: posts[index], isUserPost: true);
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: canFetchMore
                    ? const CircularProgressIndicator()
                    : (posts.isEmpty)
                        ? const Text("You didn't post anything yet.")
                        : const Text("End of the posts."),
              ),
            );
          }
        },
        itemCount: posts.length + 1,
      ),
    );
  }
}
