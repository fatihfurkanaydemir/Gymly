import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/constants/colors.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/pages/body_measurements_page.dart';
import 'package:gymly/pages/chat_page/trainees_tab.dart';
import 'package:gymly/pages/gym_page/gym_page_tabs.dart';
import 'package:gymly/pages/gym_page/trainers_tab.dart';
import 'package:gymly/pages/profile_page/profile_section.dart';
import 'package:gymly/pages/profile_page/profile_settings.dart';
import 'package:gymly/pages/profile_page/profile_tabs.dart';
import 'package:gymly/pages/trainer_workout_programs_page/view_trainer_workout_program.dart';
import 'package:gymly/providers/user_provider.dart';

import '../../providers/auth_provider.dart';
import '../trainer_workout_programs_page/trainer_workout_programs_page.dart';
import '../user_workout_programs_page/user_workout_programs_page.dart';
import 'chat_page_tabs.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  Widget buildButton(String text, void Function()? onPressed,
      [Color borderColor = Colors.cyanAccent, double borderWidth = 2.5]) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: borderWidth, color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 15),
            Icon(
              Icons.chevron_right,
              size: 40,
              color: borderColor,
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;

    if (user?.enrolledProgram != null || user?.userType == UserType.trainer) {
      return DefaultTabController(
          length: 2,
          child: SafeArea(
            child: CustomScrollView(slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(background: ChatPageTabs()),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 210,
                  width: MediaQuery.of(context).size.width - 10,
                  child: TabBarView(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // const SizedBox(height: 20),
                          // if (user?.enrolledProgram != null)
                          //   buildButton("MY SUBSCRIBED PROGRAM", () {
                          //     Navigator.of(context).pushNamed(
                          //         ViewTrainerWorkoutProgram.routeName,
                          //         arguments: {
                          //           "program": user!.enrolledProgram,
                          //           "cancelMode": true
                          //         });
                          //   }, Colors.green, 5),
                          // const SizedBox(height: 20),
                          // buildButton("WORKOUT HISTORY", () {
                          //   // Navigator.of(context)
                          //   //     .pushNamed(BodyMeasurementsPage.routeName);
                          // }),
                        ],
                      ),
                    ),
                    TraineesTab(),
                  ]),
                ),
              )
            ]),
          ));
    } else {
      return const Center(
        child: Text(
          "You have no current subscription. Enroll to a program to access trainee features.",
          style: TextStyle(fontSize: 26),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
