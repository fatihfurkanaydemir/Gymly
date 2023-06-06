import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/constants/colors.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/models/trainee.dart';
import 'package:gymly/pages/body_measurements_page.dart';
import 'package:gymly/pages/chat_page/trainees_tab.dart';
import 'package:gymly/pages/chat_page/trainer_news_tab.dart';
import 'package:gymly/pages/gym_page/gym_page_tabs.dart';
import 'package:gymly/pages/gym_page/trainers_tab.dart';
import 'package:gymly/pages/profile_page/profile_section.dart';
import 'package:gymly/pages/profile_page/profile_settings.dart';
import 'package:gymly/pages/profile_page/profile_tabs.dart';
import 'package:gymly/pages/trainer_workout_programs_page/view_trainer_workout_program.dart';
import 'package:gymly/providers/chat_provider.dart';
import 'package:gymly/providers/user_provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/hub_connection_provider.dart';
import '../trainer_workout_programs_page/trainer_workout_programs_page.dart';
import '../user_workout_programs_page/user_workout_programs_page.dart';
import 'chat_page_tabs.dart';
import 'chat_with_trainer_tab.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;
    final authUser = ref.watch(authProvider).user;
    final chat = ref.watch(chatProvider.notifier);

    if (user == null || authUser == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (user.enrolledProgram != null || user.userType == UserType.trainer) {
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
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 20, vertical: 10),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.stretch,
                    //     children: [],
                    //   ),
                    // ),
                    TrainerNewsTab(
                        isTrainerMode: user.userType == UserType.trainer),
                    if (user.userType == UserType.normal) ChatWithTrainerTab(),
                    if (user.userType == UserType.trainer) TraineesTab(),
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
