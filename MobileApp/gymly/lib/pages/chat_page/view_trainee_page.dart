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
import '../../models/workout.dart';
import '../trainer_workout_programs_page/view_trainer_workout_program.dart';
import '../workout_history_page/view_user_workout.dart';

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
      appBar: AppBar(title: const Text("Gymly")),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.all(8),
          child: FutureBuilder(
              future: traineeFuture,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  Trainee trainee = snapshot.data as Trainee;

                  return Column(
                    children: [
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
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          ExpansionTile(
                              initiallyExpanded: false,
                              childrenPadding:
                                  const EdgeInsets.only(bottom: 10),
                              collapsedBackgroundColor: Colors.white,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              collapsedTextColor: Colors.black,
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              title: const Text(
                                "Diet",
                                style: TextStyle(fontSize: 22),
                              ),
                              children: [
                                Text(
                                  trainee.diet,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ]),
                          const SizedBox(height: 10),
                          const SizedBox(height: 10),
                          ExpansionTile(
                              childrenPadding:
                                  const EdgeInsets.only(bottom: 10),
                              initiallyExpanded: false,
                              collapsedBackgroundColor: Colors.white,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              collapsedTextColor: Colors.black,
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
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
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            trainee.weight.toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            "kg",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Text(
                                            "Height: ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            trainee.height.toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            "cm",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
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
                            style: TextStyle(fontSize: 22),
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder(
                              future: ref
                                  .read(userProvider.notifier)
                                  .getWorkoutHistory(trainee.subjectId),
                              builder: ((ctx, snapshot) {
                                if (snapshot.hasData) {
                                  List<Workout> workouts = snapshot.data!;

                                  if (workouts.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        "No workouts yet",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    );
                                  }

                                  return Container(
                                    height: 270,
                                    child: ListView.builder(
                                      itemBuilder: (ctxIn, index) {
                                        return Column(
                                          children: [
                                            ViewUserWorkout(
                                              workouts[index],
                                              key: Key(
                                                workouts[index].id.toString(),
                                              ),
                                              isUserView: false,
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                        );
                                      },
                                      itemCount:
                                          user == null ? 0 : workouts.length,
                                    ),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              })),
                        ],
                      ),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
