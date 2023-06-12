import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/pages/trainer_workout_programs_page/add_trainer_workout_program.dart';
import 'package:gymly/pages/trainer_workout_programs_page/view_trainer_workout_program.dart';
import 'package:gymly/pages/user_workout_programs_page/view_user_workout_program.dart';
import 'package:gymly/providers/user_provider.dart';

class TrainerWorkoutProgramsPage extends ConsumerStatefulWidget {
  static const String routeName = "/TrainerWorkoutPrograms";

  const TrainerWorkoutProgramsPage({super.key});

  @override
  ConsumerState<TrainerWorkoutProgramsPage> createState() =>
      _TrainerWorkoutProgramsPageState();
}

class _TrainerWorkoutProgramsPageState
    extends ConsumerState<TrainerWorkoutProgramsPage> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider).user;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Gymly")),
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Your Trainer Workout Programs",
                  style: TextStyle(
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.65,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    if (user != null) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  ViewTrainerWorkoutProgram.routeName,
                                  arguments: {
                                    "program":
                                        user.trainerWorkoutPrograms[index],
                                    "trainerMode": true,
                                    "buyMode": false
                                  });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  user.trainerWorkoutPrograms[index].name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 40,
                                  color: Colors.black,
                                )
                              ],
                            )),
                      );
                    }
                  },
                  itemCount:
                      user == null ? 0 : user.trainerWorkoutPrograms.length,
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context)
                      .pushNamed(AddTrainerWorkoutProgram.routeName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Add",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 0,
              ),
            ]),
      ),
    );
  }
}
