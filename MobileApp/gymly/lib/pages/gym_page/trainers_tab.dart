import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  final resourceUrl = dotenv.env["RESOURCE_URL"];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Trainer>? trainers = ref.watch(trainerProvider).trainers;
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

    if (trainers == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(trainerProvider.notifier).refreshTrainers();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        cacheExtent: 2000,
        controller: controller,
        itemBuilder: (ctx, index) {
          if (index < trainers.length) {
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
                            ViewTrainerPage(trainers[index].subjectId)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              radius: 30,
                              backgroundImage: trainers[index].avatarUrl.isEmpty
                                  ? Image.asset("assets/images/1.jpg").image
                                  : Image.network(
                                          "$resourceUrl/${trainers[index].avatarUrl}")
                                      .image),
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
