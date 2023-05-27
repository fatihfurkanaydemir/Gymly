import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/providers/user_provider.dart';

class ProfileSettings extends ConsumerWidget {
  static const String routeName = "/ProfileSettings";

  const ProfileSettings({super.key});

  Widget buildButton(String text, void Function()? onPressed) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 2.5, color: Colors.cyan),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 15),
            const Icon(
              Icons.chevron_right,
              size: 40,
              color: Colors.cyanAccent,
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserType type = ref.watch(userProvider).user?.userType ?? UserType.normal;

    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(children: [
              buildButton(
                  "Switch to trainer account",
                  type != UserType.normal
                      ? null
                      : () async {
                          await ref
                              .read(userProvider.notifier)
                              .switchToTrainerAccountType();
                        }),
            ]),
          ),
        ));
  }
}
