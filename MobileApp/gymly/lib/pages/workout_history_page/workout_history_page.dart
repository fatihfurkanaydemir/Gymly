import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/workout.dart';
import 'package:gymly/pages/workout_history_page/view_user_workout.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/user_provider.dart';

class WorkoutHistoryPage extends ConsumerStatefulWidget {
  static const String routeName = "/WorkoutHistoryPage";

  const WorkoutHistoryPage({super.key});

  @override
  ConsumerState<WorkoutHistoryPage> createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends ConsumerState<WorkoutHistoryPage> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(authProvider).user;
    var appUser = ref.watch(userProvider).user;
    Future<List<Workout>> workoutHistoryFuture =
        ref.read(userProvider.notifier).getWorkoutHistory(user!.sub);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Gymly")),
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Your Workout History",
                  style: TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: FutureBuilder(
                    future: workoutHistoryFuture,
                    builder: ((ctx, snapshot) {
                      if (snapshot.hasData) {
                        List<Workout> workouts = snapshot.data!;

                        if (workouts.isEmpty) {
                          return const Center(
                            child: Text(
                              "You don't have any workouts yet",
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }

                        return Container(
                          child: ListView.builder(
                            itemBuilder: (ctxIn, index) {
                              return Column(
                                children: [
                                  ViewUserWorkout(
                                    workouts[index],
                                    key: Key(workouts[index].id.toString()),
                                  ),
                                  const SizedBox(height: 8)
                                ],
                              );
                            },
                            itemCount: user == null ? 0 : workouts.length,
                          ),
                        );
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    })),
              )
            ]),
      ),
    );
  }
}
