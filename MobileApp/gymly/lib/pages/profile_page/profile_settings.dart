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
    // UserType type = ref.watch(userProvider).user?.userType ?? UserType.normal;
    AppUser? user = ref.watch(userProvider).user;

    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Settings")),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(children: [
              NavigationButton(
                "Switch to trainer account",
                user.userType != UserType.normal
                    ? null
                    : () async {
                        if (user.enrolledProgram == null) {
                          await ref
                              .read(userProvider.notifier)
                              .switchToTrainerAccountType();
                        } else {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 100.0,
                                        ),
                                        const SizedBox(height: 10.0),
                                        const Text(
                                          "You are a trainee as you currently enrolled to a program. If you want to switch to trainer account type, please cancel your subscription first.",
                                          style: TextStyle(fontSize: 24),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 24.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                ),
                                                child: const Text(
                                                  "I Understand",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ));
                        }
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
