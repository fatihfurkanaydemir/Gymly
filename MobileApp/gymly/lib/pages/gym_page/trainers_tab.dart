import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/trainer.dart';
import 'package:gymly/pages/gym_page/view_trainer_page.dart';
import 'package:gymly/providers/trainer_provider.dart';

class TrainersTab extends ConsumerStatefulWidget {
  const TrainersTab({super.key});

  @override
  ConsumerState<TrainersTab> createState() => _TrainersTabState();
}

class _TrainersTabState extends ConsumerState<TrainersTab> {
  bool hasListener = false;
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Trainer> trainers = ref.watch(trainerProvider).trainers ?? [];
    bool firstFetch = ref.watch(trainerProvider).isFirstFetch ?? true;
    bool canFetchMore = ref.watch(trainerProvider).canFetchMore ?? true;

    void fetch() {
      ref.read(trainerProvider.notifier).getTrainers();
    }

    if (!hasListener) {
      controller.addListener(() {
        if (controller.position.maxScrollExtent == controller.offset) {
          fetch();
        }
      });
      setState(() {
        hasListener = true;
      });
    }

    if (firstFetch) {
      fetch();
    }

    if (trainers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(trainerProvider.notifier).refreshTrainers();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        cacheExtent: 2000,
        controller: controller,
        itemBuilder: (ctx, index) {
          if (index < trainers.length) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 2.5, color: Colors.cyan),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) =>
                            ViewTrainerPage(trainers[index].subjectId)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                Image.asset("assets/images/1.jpg").image,
                          ),
                          const SizedBox(width: 30),
                          Column(
                            children: [
                              Text(
                                trainers[index].firstName,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                trainers[index].lastName,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      const Icon(
                        Icons.chevron_right,
                        size: 40,
                        color: Colors.cyanAccent,
                      )
                    ],
                  )),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: canFetchMore
                    ? const CircularProgressIndicator()
                    : const Text("End of the list"),
              ),
            );
          }
        },
        itemCount: trainers.length + 1,
      ),
    );
  }
}
