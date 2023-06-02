import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/trainer.dart';
import 'package:gymly/pages/chat_page/view_trainee_page.dart';
import 'package:gymly/pages/gym_page/view_trainer_page.dart';
import 'package:gymly/providers/trainee_provider.dart';
import 'package:gymly/providers/trainer_provider.dart';

import '../../models/trainee.dart';

class TraineesTab extends ConsumerStatefulWidget {
  const TraineesTab({super.key});

  @override
  ConsumerState<TraineesTab> createState() => _TraineesTabState();
}

class _TraineesTabState extends ConsumerState<TraineesTab> {
  bool hasListener = false;
  bool isFirstRender = true;
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Trainee>? trainees = ref.watch(traineeProvider).trainees;
    bool firstFetch = ref.watch(traineeProvider).isFirstFetch ?? true;

    bool canFetchMore = ref.watch(traineeProvider).canFetchMore ?? true;

    void fetch() {
      ref.read(traineeProvider.notifier).getTrainees();
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

    if (trainees == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(traineeProvider.notifier).refreshTrainees();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        cacheExtent: 2000,
        controller: controller,
        itemBuilder: (ctx, index) {
          if (index < trainees.length) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) =>
                            ViewTraineePage(trainees[index].subjectId)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                Image.asset("assets/images/1.jpg").image,
                          ),
                          const SizedBox(width: 30),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "${trainees[index].firstName} ${trainees[index].lastName}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  trainees[index].enrolledProgram?.name ?? "",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      const Icon(
                        Icons.chevron_right,
                        size: 40,
                        color: Colors.black,
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
                    : trainees.isEmpty
                        ? const Text("You have no trainees yet.")
                        : const Text("End of the list"),
              ),
            );
          }
        },
        itemCount: trainees.length + 1,
      ),
    );
  }
}
