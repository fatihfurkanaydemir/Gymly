import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rive/rive.dart';

import '../../models/post.dart';

enum EmojiType {
  amazed,
  celebration,
  reachedTarget,
  flame,
  lostMind,
}

class PostEmojis extends StatelessWidget {
  final Post post;
  const PostEmojis({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PostEmoji(count: post.amazedCount, type: EmojiType.amazed),
        PostEmoji(count: post.celebrationCount, type: EmojiType.celebration),
        PostEmoji(count: post.flameCount, type: EmojiType.flame),
        PostEmoji(count: post.lostMindCount, type: EmojiType.lostMind),
        PostEmoji(
            count: post.reachedTargetCount, type: EmojiType.reachedTarget),
      ],
    );
  }
}

class PostEmoji extends StatefulWidget {
  final int count;
  final EmojiType type;
  const PostEmoji({required this.count, required this.type, super.key});

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
            onTap: () => setState(() {
              if (_isClicked != null) {
                _isClicked!.value = !_isClicked!.value;
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
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
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
