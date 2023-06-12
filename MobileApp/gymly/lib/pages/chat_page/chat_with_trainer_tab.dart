import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/auth_user.dart';
import 'package:gymly/models/chat_message.dart';
import 'package:gymly/models/trainer.dart';
import 'package:gymly/pages/chat_page/view_trainee_page.dart';
import 'package:gymly/pages/gym_page/view_trainer_page.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/chat_provider.dart';
import 'package:gymly/providers/trainee_provider.dart';
import 'package:gymly/providers/trainer_provider.dart';
import 'package:gymly/providers/user_provider.dart';
import 'package:intl/intl.dart';
import '../../models/appuser.dart';
import '../../models/trainee.dart';

class ChatWithTrainerTab extends ConsumerStatefulWidget {
  const ChatWithTrainerTab({super.key});

  @override
  ConsumerState<ChatWithTrainerTab> createState() => _ChatWithTrainerTabState();
}

class _ChatWithTrainerTabState extends ConsumerState<ChatWithTrainerTab> {
  bool hasListener = false;
  final controller = ScrollController();
  final msgInputController = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    msgInputController.dispose();
    super.dispose();
  }

  InputDecoration buildDecoration(String hintText, String suffixText) {
    return InputDecoration(
        hintText: hintText,
        suffixText: suffixText,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
                color: Colors.white, style: BorderStyle.solid, width: 2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
                color: Colors.blue, style: BorderStyle.solid, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
                color: Colors.red, style: BorderStyle.solid, width: 2)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
                color: Colors.red, style: BorderStyle.solid, width: 2)));
  }

  @override
  Widget build(BuildContext context) {
    AppUser? user = ref.watch(userProvider).user;
    AuthUser? auth = ref.watch(authProvider).user;
    List<ChatMessage>? chatHistory = ref.watch(chatProvider).messages;
    final chat = ref.watch(chatProvider.notifier);
    bool firstFetch = ref.watch(chatProvider).isFirstFetch ?? true;
    bool canFetchMore = ref.watch(chatProvider).canFetchMore ?? true;

    void fetch() {
      ref
          .read(chatProvider.notifier)
          .getChatHistory(user!.enrolledProgram!.trainerSubjectId);
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

    if (chatHistory == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.69,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            reverse: true,
            cacheExtent: 2000,
            controller: controller,
            itemBuilder: (ctx, index) {
              if (index < chatHistory.length) {
                return Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (auth!.sub == chatHistory[index].senderId)
                        const SizedBox(width: 50),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white.withAlpha(50),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              chatHistory[index].message,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withAlpha(240)),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  DateFormat('kk:mm').format(
                                      chatHistory[index].messageTime.toLocal()),
                                  style: TextStyle(
                                      color: Colors.white.withAlpha(120)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      if (auth.sub != chatHistory[index].senderId)
                        const SizedBox(width: 50),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: canFetchMore
                        ? const CircularProgressIndicator()
                        : chatHistory.isEmpty
                            ? const Text("Start a conversation.")
                            : const Text(""),
                  ),
                );
              }
            },
            itemCount: chatHistory.length + 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: msgInputController,
                  decoration: buildDecoration("Your message", ""),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white.withAlpha(60),
                radius: 32,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    if (msgInputController.value.text.trim().isNotEmpty) {
                      chat.sendMessage(msgInputController.value.text.trim(),
                          auth!.sub, user!.enrolledProgram!.trainerSubjectId);
                      msgInputController.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
