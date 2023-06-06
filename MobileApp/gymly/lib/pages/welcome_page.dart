import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gymly/pages/body_measurements_page.dart';

import '../constants/colors.dart';

class WelcomePage extends StatelessWidget {
  static const routeName = "/WelcomePage";

  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Gymly")),
        backgroundColor: Colors.black,
        body: Column(children: <Widget>[
          const Spacer(flex: 1),
          Container(
            padding: const EdgeInsets.all(70),
            child: Image.asset("assets/images/logo.png"),
          ),
          const Spacer(flex: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: const Text(
              textAlign: TextAlign.center,
              "Track your progress, get training programs from professionals, share your progress with others.",
              style: TextStyle(fontSize: 22),
            ),
          ),
          const Spacer(flex: 7),
          Row(children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryDarkColor,
                      minimumSize: const Size.fromHeight(55),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      disabledBackgroundColor: primaryDarkColor),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                        BodyMeasurementsPage.routeName,
                        arguments: {"firstLogin": true});
                  },
                  child: Text('WELCOME TO GYMLY',
                      style: TextStyle(
                          color: textColorWhite,
                          letterSpacing: 2,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ]),
          const Spacer(flex: 2),
        ]));
  }
}
