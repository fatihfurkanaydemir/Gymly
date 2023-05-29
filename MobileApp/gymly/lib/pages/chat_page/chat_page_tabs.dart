import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/constants/colors.dart';
import 'package:gymly/providers/user_provider.dart';

import '../../models/appuser.dart';

class ChatPageTabs extends ConsumerWidget {
  ChatPageTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;

    final tabs = [
      Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.newspaper),
            const SizedBox(width: 8),
            Text(user?.userType == UserType.trainer ? "Trainer News" : ""),
          ],
        ),
      ),
      Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_history_rounded),
            const SizedBox(width: 8),
            Text(user?.userType == UserType.trainer
                ? "Trainees"
                : "Trainer Chat"),
          ],
        ),
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: Colors.cyanAccent, width: 2))),
      child: SizedBox(
        height: 10,
        child: TabBar(
          enableFeedback: true,
          isScrollable: false,
          splashFactory: NoSplash.splashFactory,
          indicatorColor: Colors.cyanAccent,
          tabs: tabs,
        ),
      ),
    );
  }
}
