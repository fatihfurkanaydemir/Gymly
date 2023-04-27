import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/pages/unknown_route_page.dart';
import 'package:gymly/providers/post_provider.dart';

import '../models/post.dart';

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
    List<Post> posts = ref.watch(postProvider).posts ?? [];
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

    if (posts.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(postProvider.notifier).refreshPosts();
      },
      child: ListView.builder(
        controller: controller,
        itemBuilder: (ctx, index) {
          if (index < posts.length) {
            return Container(
              child: Text(posts[index].subjectId),
              height: 100,
              margin: const EdgeInsets.only(bottom: 5),
              color: Colors.grey,
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
