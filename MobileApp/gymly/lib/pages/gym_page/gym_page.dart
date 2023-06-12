import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/constants/colors.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/pages/body_measurements_page.dart';
import 'package:gymly/pages/components/navigation_button.dart';
import 'package:gymly/pages/gym_page/gym_page_tabs.dart';
import 'package:gymly/pages/gym_page/trainers_tab.dart';
import 'package:gymly/pages/profile_page/profile_section.dart';
import 'package:gymly/pages/profile_page/profile_settings.dart';
import 'package:gymly/pages/profile_page/profile_tabs.dart';
import 'package:gymly/pages/trainer_workout_programs_page/view_trainer_workout_program.dart';
import 'package:gymly/pages/workout_history_page/workout_history_page.dart';
import 'package:gymly/providers/user_provider.dart';

import '../../providers/auth_provider.dart';
import '../trainer_workout_programs_page/trainer_workout_programs_page.dart';
import '../user_workout_programs_page/user_workout_programs_page.dart';

class GymPage extends ConsumerWidget {
  const GymPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;

    return DefaultTabController(
        length: 2,
        child: SafeArea(
          child: CustomScrollView(slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(background: GymPageTabs()),
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
                        const SizedBox(height: 20),
                        if (user?.enrolledProgram != null)
                          NavigationButton("MY SUBSCRIBED PROGRAM", () {
                            Navigator.of(context).pushNamed(
                                ViewTrainerWorkoutProgram.routeName,
                                arguments: {
                                  "program": user!.enrolledProgram,
                                  "cancelMode": true
                                });
                          }),
                        const SizedBox(height: 20),
                        NavigationButton("WORKOUT HISTORY", () {
                          Navigator.of(context)
                              .pushNamed(WorkoutHistoryPage.routeName);
                        }),
                      ],
                    ),
                  ),
                  TrainersTab(),
                ]),
              ),
            )
          ]),
        ));
  }
}
