import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/pages/profile_page/profile_section.dart';
import 'package:gymly/providers/trainer_provider.dart';
import 'package:gymly/providers/user_provider.dart';

import '../../models/trainer.dart';
import '../trainer_workout_programs_page/view_trainer_workout_program.dart';

class ViewTrainerPage extends ConsumerStatefulWidget {
  final String trainerSubjectId;

  const ViewTrainerPage(this.trainerSubjectId, {super.key});

  @override
  ConsumerState<ViewTrainerPage> createState() => _ViewTrainerPageState();
}

class _ViewTrainerPageState extends ConsumerState<ViewTrainerPage> {
  @override
  Widget build(BuildContext context) {
    final Future<Trainer> trainerFuture = ref
        .read(trainerProvider.notifier)
        .getTrainerBySubjectId(widget.trainerSubjectId);
    final AppUser? user = ref.watch(userProvider).user;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Gymly")),
      body: FutureBuilder(
          future: trainerFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              Trainer trainer = snapshot.data as Trainer;

              return Container(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  ProfileSection(
                    userName: "${trainer.firstName} ${trainer.lastName}",
                    userEmail: "",
                    imageUrl: trainer.avatarUrl,
                    userType: UserType.trainer,
                  ),
                  Container(
                    color: Colors.cyanAccent,
                    width: double.infinity,
                    height: 2,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Programs",
                    style: TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.cyanAccent,
                    width: double.infinity,
                    height: 2,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 20),
                      itemBuilder: ((context, index) {
                        return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  width: 2.5, color: Colors.cyan),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  ViewTrainerWorkoutProgram.routeName,
                                  arguments: {
                                    "program":
                                        trainer.trainerWorkoutPrograms[index],
                                    "trainerMode": false,
                                    "buyMode":
                                        user?.userType != UserType.trainer
                                  });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  trainer.trainerWorkoutPrograms[index].name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 40,
                                  color: Colors.cyanAccent,
                                )
                              ],
                            ));
                      }),
                      itemCount: trainer.trainerWorkoutPrograms.length,
                    ),
                  ),
                ]),
              );
            }
          }),
    );
  }
}
