import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/trainer.dart';
import 'package:gymly/pages/chat_page/chat_with_trainee_page.dart';
import 'package:gymly/pages/chat_page/view_trainee_page.dart';
import 'package:gymly/pages/gym_page/view_trainer_page.dart';
import 'package:gymly/providers/chat_provider.dart';
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

  final resourceUrl = dotenv.env["RESOURCE_URL"];

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
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.785,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
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
                                  backgroundImage: trainees[index]
                                          .avatarUrl
                                          .isEmpty
                                      ? Image.asset("assets/images/1.jpg").image
                                      : Image.network(
                                              "$resourceUrl/${trainees[index].avatarUrl}")
                                          .image),
                              const SizedBox(width: 20),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "${trainees[index].firstName} ${trainees[index].lastName}",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      trainees[index].enrolledProgram?.name ??
                                          "",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: 40,
                            color: Colors.black,
                          )
                        ],
                      )),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 25),
                  ),
                  onPressed: () {
                    ref
                        .read(chatProvider.notifier)
                        .refreshChatHistory(trainees[index].subjectId);

                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return ChatWithTraineePage(trainees[index]);
                    }));
                  },
                  child: const Icon(Icons.chat),
                )
              ],
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
