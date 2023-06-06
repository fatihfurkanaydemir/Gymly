import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:gymly/models/post.dart';

import '../../helpers/svg_icons_helper.dart';

class PostHead extends StatelessWidget {
  final Post post;
  final bool isUserPost;
  final Function()? onSettingsClicked;
  PostHead(
      {required this.post,
      this.isUserPost = false,
      this.onSettingsClicked,
      super.key});

  final resourceUrl = dotenv.env["RESOURCE_URL"];

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
                  backgroundImage: post.user.avatarUrl.isEmpty
                      ? Image.asset("assets/images/1.jpg").image
                      : Image.network("$resourceUrl/${post.user.avatarUrl}")
                          .image),
              const SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "${post.user.firstName} ${post.user.lastName}",
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
          if (isUserPost)
            GestureDetector(
              onTap: () {
                if (onSettingsClicked == null) return;
                onSettingsClicked!();
              },
              child: SvgIconsHelper.fromSvg(
                svgPath: "assets/icons/items.svg",
                size: 15,
                color: Theme.of(context).primaryColor.withOpacity(.6),
              ),
            ),
        ],
      ),
    );
  }
}
