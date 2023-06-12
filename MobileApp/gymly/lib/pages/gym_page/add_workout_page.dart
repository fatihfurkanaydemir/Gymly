import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/user_workout_program.dart';
import 'package:gymly/models/workout.dart';
import 'package:gymly/pages/add_post_page/add_post_page_image_preview.dart';
import 'package:gymly/providers/post_provider.dart';
import 'package:gymly/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/appuser.dart';

class AddWorkoutPage extends ConsumerStatefulWidget {
  static const String routeName = "/AddWorkout";

  const AddWorkoutPage({super.key});

  @override
  ConsumerState<AddWorkoutPage> createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends ConsumerState<AddWorkoutPage> {
  final _formKey = GlobalKey<FormState>();

  int duration = 0;
  int? selectedWorkout;

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
    AppUser? user = ref.watch(userProvider).user;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Add new workout"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: (user == null || user.userWorkoutPrograms.isEmpty)
            ? const Center(
                child: Text(
                  "Please add a workout program first.",
                  style: TextStyle(fontSize: 22),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 80,
                              child: TextFormField(
                                onSaved: (newValue) {
                                  duration = int.tryParse(newValue ?? "") ?? 0;
                                },
                                decoration: buildDecoration("Duration", "mins"),
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a value';
                                  } else if ((int.tryParse(value) ?? 0) <= 0) {
                                    return 'Please enter a value greater than 0';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            DropdownButtonFormField<int>(
                              value: selectedWorkout,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              isExpanded: true,
                              decoration: buildDecoration(
                                  "Select the workout program", ""),
                              onSaved: (newValue) {
                                selectedWorkout = newValue;
                              },
                              onChanged: (value) {
                                setState(() {
                                  selectedWorkout = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value == 0) {
                                  return "Please select a workout program";
                                }

                                return null;
                              },
                              items: user.userWorkoutPrograms
                                  .map<DropdownMenuItem<int>>(
                                      (UserWorkoutProgram value) {
                                return DropdownMenuItem<int>(
                                  value: value.id,
                                  child: Text(
                                    value.title,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            final isAdded = await ref
                                .read(userProvider.notifier)
                                .createWorkout(duration, selectedWorkout!);

                            if (isAdded) {
                              Navigator.of(context).pop(true);
                              ref.read(userProvider.notifier).getUser();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            Text(
                              "Add",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
