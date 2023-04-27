import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gymly/pages/body_measurements_page.dart';

class WelcomePage extends StatelessWidget {
  static const routeName = "/WelcomePage";

  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gymly")),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(BodyMeasurementsPage.routeName);
            },
            child: const Text("WELCOME TO APP")),
      ),
    );
  }
}
