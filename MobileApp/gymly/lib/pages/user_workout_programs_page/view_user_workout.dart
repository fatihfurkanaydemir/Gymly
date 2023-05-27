import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/user_workout_program.dart';

import '../../providers/user_provider.dart';

class ViewUserWorkout extends ConsumerStatefulWidget {
  final UserWorkoutProgram program;
  const ViewUserWorkout(this.program, {super.key});

  @override
  ConsumerState<ViewUserWorkout> createState() => _ViewUserWorkoutState();
}

class _ViewUserWorkoutState extends ConsumerState<ViewUserWorkout> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String description = "";
  String content = "";

  @override
  void initState() {
    super.initState();
    title = widget.program.title;
    description =
        widget.program.description.isEmpty ? "" : widget.program.description;
    content = widget.program.content;
  }

  InputDecoration buildDecoration(
      [String hintText = "", String suffixText = ""]) {
    return InputDecoration(
        hintText: hintText,
        suffixText: suffixText,
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
                color: Colors.blue, style: BorderStyle.solid, width: 1)),
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
    return Container(
      child: ExpansionTile(
        collapsedBackgroundColor: Colors.black,
        backgroundColor: Colors.black,
        title: Text(
          widget.program.title,
          style: const TextStyle(fontSize: 16),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              SizedBox(
                height: 70,
                child: TextFormField(
                  expands: true,
                  enabled: false,
                  initialValue: widget.program.description.isEmpty
                      ? "No description"
                      : widget.program.description,
                  maxLines: null,
                  minLines: null,
                  decoration: buildDecoration(),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 300,
                child: TextFormField(
                  maxLines: 15,
                  minLines: 15,
                  enabled: false,
                  initialValue: widget.program.content,
                  keyboardType: TextInputType.multiline,
                  decoration: buildDecoration(),
                ),
              ),
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
                                      initialValue: title,
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
                                      initialValue: description,
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
                                      initialValue: content,
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
                                            .updateUserWorkoutProgram(
                                              widget.program.id,
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
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
