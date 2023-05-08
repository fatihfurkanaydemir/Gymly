import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:gymly/models/post.dart';

import '../../helpers/svg_icons_helper.dart';

class PostHead extends StatelessWidget {
  final Post post;
  const PostHead({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: Image.asset("assets/images/1.jpg").image,
              ),
              const SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "Author Name", //post.authorName,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  ),
                  AutoSizeText(
                    "${DateTime.now().difference(post.createDate).inMinutes} min ago",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black.withOpacity(0.4)),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              // SvgIconsHelper.fromSvg(
              //   svgPath: "assets/icons/send.svg",
              //   size: 20,
              //   color: Theme.of(context).primaryColor.withOpacity(.6),
              // ),
              // const SizedBox(width: 10),
              SvgIconsHelper.fromSvg(
                svgPath: "assets/icons/items.svg",
                size: 15,
                color: Theme.of(context).primaryColor.withOpacity(.6),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
