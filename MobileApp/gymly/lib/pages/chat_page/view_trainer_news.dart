import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/trainer_news.dart';
import 'package:gymly/providers/trainer_news_provider.dart';

import '../../providers/user_provider.dart';

class ViewTrainerNews extends ConsumerStatefulWidget {
  final TrainerNews news;
  final bool isTrainerMode;
  const ViewTrainerNews(this.news, {this.isTrainerMode = false, super.key});

  @override
  ConsumerState<ViewTrainerNews> createState() => _ViewUserWorkoutState();
}

class _ViewUserWorkoutState extends ConsumerState<ViewTrainerNews> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String content = "";

  @override
  void initState() {
    super.initState();
    title = widget.news.title;
    content = widget.news.content;
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
    return ExpansionTile(
      initiallyExpanded: false,
      collapsedBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      collapsedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      collapsedTextColor: Colors.black,
      iconColor: Colors.black,
      collapsedIconColor: Colors.black,
      title: Text(
        widget.news.title,
        style: const TextStyle(fontSize: 16),
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            SizedBox(
              height: 300,
              child: TextFormField(
                maxLines: 15,
                style: const TextStyle(color: Colors.black),
                minLines: 15,
                enabled: false,
                initialValue: widget.news.content,
                keyboardType: TextInputType.multiline,
                decoration: buildDecoration(),
              ),
            ),
            if (widget.isTrainerMode)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final isDeleted = await ref
                            .read(trainerNewsProvider.notifier)
                            .deleteTrainerNews(
                              id: widget.news.id,
                            );
                        if (isDeleted) {
                          ref
                              .read(trainerNewsProvider.notifier)
                              .refreshTrainerNews(widget.news.subjectId);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
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
              )
          ]),
        )
      ],
    );
  }
}
