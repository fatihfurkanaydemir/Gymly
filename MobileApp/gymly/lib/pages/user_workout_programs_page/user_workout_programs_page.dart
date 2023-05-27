import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/pages/user_workout_programs_page/view_user_workout.dart';
import 'package:gymly/providers/user_provider.dart';

class UserWorkoutProgramsPage extends ConsumerStatefulWidget {
  static const String routeName = "/UserWorkoutPrograms";

  const UserWorkoutProgramsPage({super.key});

  @override
  ConsumerState<UserWorkoutProgramsPage> createState() =>
      _UserWorkoutProgramsPageState();
}

class _UserWorkoutProgramsPageState
    extends ConsumerState<UserWorkoutProgramsPage> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String description = "";
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
                  "Your Workout Programs",
                  style: TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    if (user != null) {
                      return Column(
                        children: [
                          ViewUserWorkout(
                            user.userWorkoutPrograms[index],
                            key: Key(
                                user.userWorkoutPrograms[index].id.toString()),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 2,
                            child: Container(
                              color: Colors.cyan,
                            ),
                          )
                        ],
                      );
                    }
                  },
                  itemCount: user == null ? 0 : user.userWorkoutPrograms.length,
                ),
              ),
              const SizedBox(height: 15),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
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
                                    height: 70,
                                    child: TextFormField(
                                      onSaved: (newValue) {
                                        description = newValue ?? "";
                                      },
                                      expands: true,
                                      maxLines: null,
                                      minLines: null,
                                      decoration: buildDecoration(
                                          "Description (optional)", ""),
                                      validator: (value) {
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
                                      decoration:
                                          buildDecoration("Content", ""),
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
                                            .read(userProvider.notifier)
                                            .addUserWorkoutProgram(
                                              title,
                                              description,
                                              content,
                                            );
                                        if (isAdded) {
                                          ref
                                              .read(userProvider.notifier)
                                              .getUser();
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              color: Colors.white,
                                              fontSize: 22),
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
