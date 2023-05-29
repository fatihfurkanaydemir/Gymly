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
                  SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.55,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            ExpansionTile(
                                initiallyExpanded: false,
                                collapsedBackgroundColor: Colors.black,
                                backgroundColor: Colors.black,
                                title: const Text(
                                  "Diet",
                                  style: const TextStyle(fontSize: 22),
                                ),
                                children: [
                                  Text(trainee.diet),
                                ]),
                            const SizedBox(height: 10),
                            Container(
                              color: Colors.cyanAccent,
                              width: double.infinity,
                              height: 2,
                            ),
                            const SizedBox(height: 10),
                            ExpansionTile(
                                initiallyExpanded: false,
                                collapsedBackgroundColor: Colors.black,
                                backgroundColor: Colors.black,
                                title: const Text(
                                  "Measurements",
                                  style: TextStyle(fontSize: 22),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Weight: ",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              trainee.weight.toStringAsFixed(2),
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              "kg",
                                              style: TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Text(
                                              "Height: ",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              trainee.height.toStringAsFixed(2),
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              "cm",
                                              style: TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                            const SizedBox(height: 10),
                            Container(
                              color: Colors.cyanAccent,
                              width: double.infinity,
                              height: 2,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Workout History",
                              style: const TextStyle(fontSize: 22),
                            ),
                          ],
                        )),
                  ),
                ]),
              );
            }
          }),
    );
  }
}
