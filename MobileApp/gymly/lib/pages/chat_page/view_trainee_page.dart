import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/pages/profile_page/profile_section.dart';
import 'package:gymly/providers/trainer_provider.dart';
import 'package:gymly/providers/user_provider.dart';

import '../../models/trainee.dart';
import '../../models/trainer.dart';
import '../trainer_workout_programs_page/view_trainer_workout_program.dart';

class ViewTraineePage extends ConsumerStatefulWidget {
  final String trainerSubjectId;

  const ViewTraineePage(this.trainerSubjectId, {super.key});

  @override
  ConsumerState<ViewTraineePage> createState() => _ViewTraineePageState();
}

class _ViewTraineePageState extends ConsumerState<ViewTraineePage> {
  @override
  Widget build(BuildContext context) {
    final Future<Trainee> traineeFuture = ref
        .read(trainerProvider.notifier)
        .getTraineeBySubjectId(widget.trainerSubjectId);
    final AppUser? user = ref.watch(userProvider).user;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Gymly")),
      body: FutureBuilder(
          future: traineeFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              Trainee trainee = snapshot.data as Trainee;

              return Container(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  ProfileSection(
                    userName: "${trainee.firstName} ${trainee.lastName}",
                    userEmail: "",
                    imageUrl: trainee.avatarUrl,
                    userType: UserType.normal,
                    programName: trainee.enrolledProgram!.name,
                  ),
                  Container(
                    color: Colors.cyanAccent,
                    width: double.infinity,
                    height: 2,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Details",
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
                          // return Container(
                          //   margin: const EdgeInsets.only(top: 10),
                          //   child: OutlinedButton(
                          //       style: OutlinedButton.styleFrom(
                          //         side: const BorderSide(
                          //             width: 2.5, color: Colors.cyan),
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 20, vertical: 10),
                          //       ),
                          //       onPressed: () {
                          //         Navigator.of(context).pushNamed(
                          //             ViewTrainerWorkoutProgram.routeName,
                          //             arguments: {
                          //               "program":
                          //                   trainer.trainerWorkoutPrograms[index],
                          //               "trainerMode": false,
                          //               "buyMode":
                          //                   user?.userType != UserType.trainer
                          //             });
                          //       },
                          //       child: Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Text(
                          //             trainer.trainerWorkoutPrograms[index].name,
                          //             style: const TextStyle(fontSize: 16),
                          //           ),
                          //           const Icon(
                          //             Icons.chevron_right,
                          //             size: 40,
                          //             color: Colors.cyanAccent,
                          //           )
                          //         ],
                          //       )),
                          // );
                        }),
                        itemCount: 0 //trainer.trainerWorkoutPrograms.length,
                        ),
                  ),
                ]),
              );
            }
          }),
    );
  }
}
