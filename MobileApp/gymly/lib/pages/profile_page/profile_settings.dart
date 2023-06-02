import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/pages/components/navigation_button.dart';
import 'package:gymly/providers/user_provider.dart';

import '../../providers/auth_provider.dart';

class ProfileSettings extends ConsumerWidget {
  static const String routeName = "/ProfileSettings";

  const ProfileSettings({super.key});

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
              NavigationButton(
                "Switch to trainer account",
                type != UserType.normal
                    ? null
                    : () async {
                        await ref
                            .read(userProvider.notifier)
                            .switchToTrainerAccountType();
                      },
              ),
              const SizedBox(height: 10),
              NavigationButton("Logout", () {
                ref.read(authProvider.notifier).logout();
                Navigator.of(context).pop();
              }),
            ]),
          ),
        ));
  }
}
