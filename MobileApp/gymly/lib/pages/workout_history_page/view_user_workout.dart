import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/user_workout_program.dart';
import 'package:gymly/models/workout.dart';

import '../../providers/user_provider.dart';

class ViewUserWorkout extends ConsumerStatefulWidget {
  final Workout workout;
  final bool isUserView;
  const ViewUserWorkout(this.workout, {this.isUserView = true, super.key});

  @override
  ConsumerState<ViewUserWorkout> createState() => _ViewUserWorkoutState();
}

class _ViewUserWorkoutState extends ConsumerState<ViewUserWorkout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile(
        initiallyExpanded: false,
        childrenPadding: widget.isUserView
            ? const EdgeInsets.only(bottom: 0)
            : const EdgeInsets.only(bottom: 10),
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        collapsedTextColor: Colors.black,
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.workout.programTitle,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "${widget.workout.created.day}/${widget.workout.created.month}/${widget.workout.created.year}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "${widget.workout.durationInMinutes} mins",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  widget.workout.programContent,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
          if (widget.isUserView)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: ElevatedButton(
                onPressed: () async {
                  final isDeleted =
                      await ref.read(userProvider.notifier).deleteWorkout(
                            widget.workout.id,
                          );
                  if (isDeleted) {
                    ref.read(userProvider.notifier).getUser();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
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
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
