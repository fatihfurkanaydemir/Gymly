import 'package:flutter/material.dart';
import 'package:gymly/constants/colors.dart';

class ProfileTabs extends StatelessWidget {
  const ProfileTabs({super.key});

  static const tabTexts = ["Posts", "Activity"];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xFF252735),
          border: Border(top: BorderSide(color: Colors.white))),
      child: TabBar(
        enableFeedback: false,
        isScrollable: false,
        splashFactory: NoSplash.splashFactory,
        automaticIndicatorColorAdjustment: true,
        indicatorSize: TabBarIndicatorSize.label,
        // labelColor: Color(0xFF252735),
        labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).primaryColor,
            ),
        labelColor: textColorWhite,
        unselectedLabelStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.black.withOpacity(.8)),
        indicatorColor: Colors.pink,
        tabs: tabTexts
            .map(
              (e) => Tab(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    e,
                    // style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    //       color: Theme.of(context).primaryColor,
                    //     ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
