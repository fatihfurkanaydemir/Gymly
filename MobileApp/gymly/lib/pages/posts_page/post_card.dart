import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gymly/pages/posts_page/post_emojis.dart';
import 'package:gymly/pages/posts_page/post_head.dart';
import 'package:gymly/pages/posts_page/post_images.dart';

import '../../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
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
          ),
          SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PostImages(
                  post: post,
                ),
                // PostEmojis(
                //   post: post,
                // )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 7.5,
                ),
                // AutoSizeText.rich(
                //   TextSpan(
                //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                //           fontWeight: FontWeight.w400,
                //           color: Colors.black.withOpacity(.6),
                //         ),
                //     children: [
                //       const TextSpan(text: "Liked by "),
                //       TextSpan(
                //         text: "${post.amazedCount}",
                //         style: const TextStyle(
                //             fontWeight: FontWeight.w700, color: Colors.black),
                //       ),
                //       const TextSpan(text: " people"),
                //     ],
                //   ),
                // ),

                const SizedBox(
                  height: 10,
                ),
                AutoSizeText.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 14,
                        ),
                    children: [
                      // TextSpan(
                      //   text: "${post.title} ",
                      //   style: const TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      TextSpan(
                        text: post.content,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                PostEmojis(
                  post: post,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
