import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/pages/home_page.dart';
import 'package:gymly/providers/auth_provider.dart';

class BodyMeasurementsPage extends ConsumerStatefulWidget {
  static const routeName = "/BodyMeasurementsPage";
  const BodyMeasurementsPage({super.key});

  @override
  BodyMeasurementsPageState createState() => BodyMeasurementsPageState();
}

class BodyMeasurementsPageState extends ConsumerState<BodyMeasurementsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gymly")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Save"),
          onPressed: () {
            ref.read(authProvider.notifier).cancelFirstLogin();
            Navigator.of(context).pushReplacementNamed(HomePage.routeName);
          },
        ),
      ),
    );
  }
}
