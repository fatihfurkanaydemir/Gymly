import 'package:flutter/material.dart';
import 'package:gymly/constants/colors.dart';

class ProfileTabs extends StatelessWidget {
  ProfileTabs({super.key});

  final tabs = [
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.location_history_rounded),
          SizedBox(width: 8),
          Text("Posts"),
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.bolt_rounded),
          SizedBox(width: 8),
          Text("Personal"),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
