import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/post_interaction.dart';
import 'package:gymly/pages/posts_page/post_emojis.dart';
import 'package:gymly/pages/posts_page/post_head.dart';
import 'package:gymly/pages/posts_page/post_images.dart';
import 'package:gymly/providers/post_provider.dart';
import 'package:gymly/providers/user_posts_provider.dart';

import '../../models/post.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  final PostInteraction interaction;
  final bool isUserPost;
  const PostCard(
      {required this.post,
      required this.interaction,
      this.isUserPost = false,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHead(
            post: post,
            isUserPost: isUserPost,
            onSettingsClicked: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    color: Colors.black.withAlpha(230),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 8,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final isDeleted = await ref
                                      .read(userPostsProvider.notifier)
                                      .deletePost(id: post.id);
                                  if (isDeleted) {
                                    ref
                                        .read(userPostsProvider.notifier)
                                        .refreshPosts(post.subjectId);
                                    Navigator.pop(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      "Delete",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(flex: 1),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          PostImages(
            post: post,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                AutoSizeText.rich(
                  TextSpan(
                    text: post.content,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 14,
                        ),
                  ),
                ),
                PostEmojis(
                    post: post,
                    isUserPost: isUserPost,
                    userInteraction: interaction),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
