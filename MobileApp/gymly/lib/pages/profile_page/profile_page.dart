import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/constants/colors.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/pages/body_measurements_page.dart';
import 'package:gymly/pages/profile_page/profile_section.dart';
import 'package:gymly/pages/profile_page/profile_settings.dart';
import 'package:gymly/pages/profile_page/profile_tabs.dart';
import 'package:gymly/providers/user_provider.dart';

import '../../providers/auth_provider.dart';
import '../trainer_workout_programs_page/trainer_workout_programs_page.dart';
import '../user_workout_programs_page/user_workout_programs_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Widget buildButton(String text, void Function()? onPressed) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 2.5, color: Colors.cyan),
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
            const Icon(
              Icons.chevron_right,
              size: 40,
              color: Colors.cyanAccent,
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = ref.watch(userProvider).user;

    return DefaultTabController(
        length: 2,
        child: SafeArea(
          child: CustomScrollView(slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(ProfileSettings.routeName);
                  },
                  icon: const Icon(Icons.settings),
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                )
              ],
              backgroundColor: Colors.black,
              pinned: true,
              title: Text(
                'Gymly',
                style: TextStyle(color: textColorWhite),
              ),
            ),
            SliverAppBar(
              expandedHeight: 270,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: ProfileSection(
                  userName: auth.user?.name ?? '-',
                  userEmail: auth.user?.email ?? '-',
                  userType: user?.userType ?? UserType.normal,
                  imageUrl: '',
                ),
              ),
            ),
            SliverAppBar(
              pinned: true,
              // expandedHeight: 20,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(background: ProfileTabs()),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 210,
                width: MediaQuery.of(context).size.width - 10,
                child: TabBarView(children: [
                  Column(
                    children: [
                      Text(auth.user!.sub),
                      Text(auth.user!.name),
                      Text(auth.user!.email),
                      Text(user == null ? "" : user.height.toString()),
                      OutlinedButton(
                        onPressed: () {
                          ref.read(authProvider.notifier).logout();
                        },
                        child: const Text("Logout"),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 50),
                        buildButton("BODY MEASUREMENTS", () {
                          Navigator.of(context)
                              .pushNamed(BodyMeasurementsPage.routeName);
                        }),
                        const SizedBox(height: 15),
                        buildButton("WORKOUT PROGRAMS", () {
                          Navigator.of(context)
                              .pushNamed(UserWorkoutProgramsPage.routeName);
                        }),
                        const SizedBox(height: 15),
                        if (user?.userType == UserType.trainer)
                          buildButton("TRAINER WORKOUT PROGRAMS", () {
                            Navigator.of(context).pushNamed(
                                TrainerWorkoutProgramsPage.routeName);
                          }),
                      ],
                    ),
                  )
                ]),
              ),
            )
          ]),
        ));
  }
}
