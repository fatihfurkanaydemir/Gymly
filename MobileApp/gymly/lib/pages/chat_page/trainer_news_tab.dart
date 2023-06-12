import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/auth_user.dart';
import 'package:gymly/pages/chat_page/view_trainee_page.dart';
import 'package:gymly/pages/chat_page/view_trainer_news.dart';
import 'package:gymly/pages/user_workout_programs_page/view_user_workout_program.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/trainer_news_provider.dart';
import 'package:gymly/providers/user_provider.dart';

import '../../models/appuser.dart';
import '../../models/trainer_news.dart';

class TrainerNewsTab extends ConsumerStatefulWidget {
  static const String routeName = "/TrainerNews";
  final bool isTrainerMode;
  const TrainerNewsTab({this.isTrainerMode = false, super.key});

  @override
  ConsumerState<TrainerNewsTab> createState() => _TrainerNewsTabState();
}

class _TrainerNewsTabState extends ConsumerState<TrainerNewsTab> {
  bool hasListener = false;
  bool isFirstRender = true;
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  String title = "";
  String content = "";

  InputDecoration buildDecoration(String hintText, String suffixText) {
    return InputDecoration(
        hintText: hintText,
        suffixText: suffixText,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
                color: Colors.white, style: BorderStyle.solid, width: 2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
                color: Colors.blue, style: BorderStyle.solid, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
                color: Colors.red, style: BorderStyle.solid, width: 2)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
                color: Colors.red, style: BorderStyle.solid, width: 2)));
  }

  @override
  Widget build(BuildContext context) {
    List<TrainerNews>? news = ref.watch(trainerNewsProvider).news;
    bool firstFetch = ref.watch(trainerNewsProvider).isFirstFetch ?? true;
    bool canFetchMore = ref.watch(trainerNewsProvider).canFetchMore ?? true;

    AppUser? user = ref.watch(userProvider).user;
    AuthUser? auth = ref.watch(authProvider).user;

    if (user == null || auth == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    void fetch() {
      ref.read(trainerNewsProvider.notifier).getTrainerNews(widget.isTrainerMode
          ? auth.sub
          : user.enrolledProgram!.trainerSubjectId);
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

    if (news == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const SizedBox(height: 20),
        Container(
          height: MediaQuery.of(context).size.height *
              (widget.isTrainerMode ? 0.63 : 0.70),
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(trainerNewsProvider.notifier).refreshTrainerNews(
                    widget.isTrainerMode
                        ? auth.sub
                        : user.enrolledProgram!.trainerSubjectId,
                  );
            },
            child: news.isEmpty
                ? const Center(
                    child: Text("No news yet."),
                  )
                : ListView.builder(
                    addAutomaticKeepAlives: true,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          ViewTrainerNews(
                            news[index],
                            isTrainerMode: widget.isTrainerMode,
                            key: Key(news[index].id.toString()),
                          ),
                          const SizedBox(height: 8)
                        ],
                      );
                    },
                    itemCount: news.length,
                  ),
          ),
        ),
        const SizedBox(height: 15),
        if (widget.isTrainerMode)
          ElevatedButton(
            onPressed: () async {
              showModalBottomSheet<void>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    color: Colors.black.withAlpha(230),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 8,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 70,
                                child: TextFormField(
                                  onSaved: (newValue) {
                                    title = newValue ?? "";
                                  },
                                  expands: true,
                                  maxLines: null,
                                  minLines: null,
                                  decoration: buildDecoration("Title", ""),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a value';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                height: 300,
                                child: TextFormField(
                                  onSaved: (newValue) {
                                    content = newValue ?? "";
                                  },
                                  maxLines: 15,
                                  minLines: 15,
                                  decoration: buildDecoration("Content", ""),
                                  keyboardType: TextInputType.multiline,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a value';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(flex: 1),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    final isAdded = await ref
                                        .read(trainerNewsProvider.notifier)
                                        .createTrainerNews(
                                          title: title,
                                          content: content,
                                        );
                                    if (isAdded) {
                                      ref
                                          .read(trainerNewsProvider.notifier)
                                          .refreshTrainerNews(
                                              widget.isTrainerMode
                                                  ? auth.sub
                                                  : user.enrolledProgram!
                                                      .trainerSubjectId);
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.save,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      "Save",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
    );
  }
}
