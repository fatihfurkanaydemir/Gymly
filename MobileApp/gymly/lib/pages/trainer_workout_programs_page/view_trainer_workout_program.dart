import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/trainer_workout_program.dart';

import '../../providers/user_provider.dart';

class ViewTrainerWorkoutProgram extends ConsumerWidget {
  static const String routeName = "/ViewTrainerWorkoutProgram";
  final TrainerWorkoutProgram program;
  final bool trainerMode;
  final bool buyMode;

  final resourceUrl = dotenv.env["RESOURCE_URL"];

  ViewTrainerWorkoutProgram(this.program,
      {this.trainerMode = false, this.buyMode = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Gymly")),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Text(
                  program.name,
                  style: const TextStyle(
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyan, width: 2),
                      borderRadius: BorderRadius.circular(50)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Text(
                    "${program.price.toStringAsFixed(2)}₺",
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Image.network(
                  "$resourceUrl/${program.headerImageUrl}",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  program.title,
                  style: const TextStyle(
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(program.description),
                    const SizedBox(height: 20),
                    Text(program.programDetails),
                    const SizedBox(height: 20),
                    if (trainerMode)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    "Edit",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final isDeleted = await ref
                                    .read(userProvider.notifier)
                                    .deleteTrainerWorkoutProgram(
                                      program.id,
                                    );
                                if (isDeleted) {
                                  ref.read(userProvider.notifier).getUser();
                                  Navigator.of(context).pop();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    "Delete",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (buyMode)
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 15),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "Enroll to Program",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
