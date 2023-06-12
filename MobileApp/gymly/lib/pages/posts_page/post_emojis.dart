import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/post_interaction.dart';
import 'package:gymly/providers/post_provider.dart';
import 'package:rive/rive.dart';

import '../../models/post.dart';

enum EmojiType {
  amazed,
  celebration,
  reachedTarget,
  flame,
  lostMind,
}

class PostEmojis extends ConsumerWidget {
  final Post post;
  final bool isUserPost;
  final PostInteraction userInteraction;

  const PostEmojis({
    required this.post,
    this.isUserPost = false,
    required this.userInteraction,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PostEmoji(
          count: post.amazedCount,
          type: EmojiType.amazed,
          isUserPost: isUserPost,
          isClicked: userInteraction.amazed,
          onClicked: (newVal) {
            ref
                .read(postProvider.notifier)
                .interactWithPost(userInteraction.copyWith(amazed: newVal));
          },
        ),
        PostEmoji(
          count: post.celebrationCount,
          type: EmojiType.celebration,
          isUserPost: isUserPost,
          isClicked: userInteraction.celebration,
          onClicked: (newVal) {
            ref.read(postProvider.notifier).interactWithPost(
                userInteraction.copyWith(celebration: newVal));
          },
        ),
        PostEmoji(
          count: post.flameCount,
          type: EmojiType.flame,
          isUserPost: isUserPost,
          isClicked: userInteraction.flame,
          onClicked: (newVal) {
            ref
                .read(postProvider.notifier)
                .interactWithPost(userInteraction.copyWith(flame: newVal));
          },
        ),
        PostEmoji(
          count: post.lostMindCount,
          type: EmojiType.lostMind,
          isUserPost: isUserPost,
          isClicked: userInteraction.lostMind,
          onClicked: (newVal) {
            ref
                .read(postProvider.notifier)
                .interactWithPost(userInteraction.copyWith(lostMind: newVal));
          },
        ),
        PostEmoji(
          count: post.reachedTargetCount,
          type: EmojiType.reachedTarget,
          isUserPost: isUserPost,
          isClicked: userInteraction.reachedTarget,
          onClicked: (newVal) {
            ref.read(postProvider.notifier).interactWithPost(
                userInteraction.copyWith(reachedTarget: newVal));
          },
        ),
      ],
    );
  }
}

class PostEmoji extends StatefulWidget {
  final int count;
  final EmojiType type;
  final bool isUserPost;
  final bool isClicked;
  final Function(bool) onClicked;

  const PostEmoji({
    required this.count,
    required this.type,
    this.isUserPost = false,
    this.isClicked = false,
    required this.onClicked,
    super.key,
  });

  @override
  State<PostEmoji> createState() => _PostEmojiState();
}

class _PostEmojiState extends State<PostEmoji> {
  String artboard = "";

  late StateMachineController _controller;
  SMIBool? _isClicked;

  void _OnRiveInit(Artboard art) {
    var ctrl = StateMachineController.fromArtboard(art, 'controller')
        as StateMachineController;
    ctrl.isActive = true;
    art.addController(ctrl);

    _isClicked = ctrl.findInput<bool>('isHover') as SMIBool;
    if (widget.isUserPost) {
      _isClicked!.value = true;
    } else {
      _isClicked!.value = widget.isClicked;
    }
    setState(() {
      _controller = ctrl;
    });
  }

  @override
  void initState() {
    super.initState();

    switch (widget.type) {
      case EmojiType.amazed:
        artboard = "love";
        break;
      case EmojiType.celebration:
        artboard = "Tada";
        break;
      case EmojiType.flame:
        artboard = "Onfire";
        break;
      case EmojiType.reachedTarget:
        artboard = "Bullseye";
        break;
      case EmojiType.lostMind:
        artboard = "Mindblown";
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 70,
          child: GestureDetector(
            onTap: widget.isUserPost
                ? null
                : () => setState(() {
                      if (_isClicked != null) {
                        _isClicked!.value = !_isClicked!.value;
                        widget.onClicked(_isClicked!.value);
                      }
                    }),
            child: RiveAnimation.asset(
              'assets/rive_animations/rives_animated_emojis.riv',
              artboard: artboard,
              fit: BoxFit.scaleDown,
              onInit: _OnRiveInit,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.7),
            borderRadius: BorderRadius.circular(30),
          ),
          child: AutoSizeText(
            "${widget.count}",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 4,
                ),
          ),
        ),
      ],
    );
  }
}
