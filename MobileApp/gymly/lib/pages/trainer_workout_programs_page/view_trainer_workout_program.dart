import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/models/trainer_workout_program.dart';
import 'package:gymly/pages/home_page.dart';
import 'package:gymly/providers/workout_provider.dart';
import 'package:http/http.dart' as http;

import '../../providers/user_provider.dart';

class ViewTrainerWorkoutProgram extends ConsumerStatefulWidget {
  static const String routeName = "/ViewTrainerWorkoutProgram";
  final TrainerWorkoutProgram program;
  final bool trainerMode;
  final bool buyMode;
  final bool cancelMode;

  ViewTrainerWorkoutProgram(this.program,
      {this.trainerMode = false,
      this.buyMode = false,
      this.cancelMode = false,
      super.key});

  @override
  ConsumerState<ViewTrainerWorkoutProgram> createState() =>
      _ViewTrainerWorkoutProgramState();
}

class _ViewTrainerWorkoutProgramState
    extends ConsumerState<ViewTrainerWorkoutProgram> {
  final resourceUrl = dotenv.env["RESOURCE_URL"];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final AppUser? user = ref.watch(userProvider).user;
    Map<String, dynamic>? paymentIntent;

    createPaymentIntent(String amount, String currency) async {
      try {
        //Request body
        Map<String, dynamic> body = {
          'amount': amount,
          'currency': currency,
        };

        //Make post request to Stripe
        var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: body,
        );
        return json.decode(response.body);
      } catch (err) {
        throw Exception(err.toString());
      }
    }

    displayPaymentSheet() async {
      try {
        await Stripe.instance.presentPaymentSheet().then((value) async {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 100.0,
                        ),
                        SizedBox(height: 10.0),
                        Text("Payment Successful!"),
                      ],
                    ),
                  ));
          paymentIntent = null;
          await ref
              .read(workoutProvider.notifier)
              .enrollUserToProgram(widget.program.id);
          await ref.read(userProvider.notifier).getUser();
          Navigator.of(context)
              .popUntil(ModalRoute.withName(HomePage.routeName));
        }).onError((error, stackTrace) {
          setState(() {
            isLoading = false;
          });
          throw Exception(error);
        });
      } on StripeException catch (e) {
        print('Error is:---> $e');
        setState(() {
          isLoading = false;
        });
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  Text("Payment Failed"),
                ],
              ),
            ],
          ),
        );
      } catch (e) {
        print('$e');
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Gymly")),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Text(
                  widget.program.name,
                  style: const TextStyle(
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyan, width: 2),
                      borderRadius: BorderRadius.circular(50)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Text(
                    "${widget.program.price.toStringAsFixed(2)}₺",
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Image.network(
                  "$resourceUrl/${widget.program.headerImageUrl}",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  widget.program.title,
                  style: const TextStyle(
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(widget.program.description),
                    const SizedBox(height: 20),
                    Text(widget.program.programDetails),
                    const SizedBox(height: 20),
                    if (widget.trainerMode)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {},
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
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final isDeleted = await ref
                                    .read(userProvider.notifier)
                                    .deleteTrainerWorkoutProgram(
                                      widget.program.id,
                                    );
                                if (isDeleted) {
                                  ref.read(userProvider.notifier).getUser();
                                  Navigator.of(context).pop();
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
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (widget.buyMode)
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : (user?.enrolledProgram != null
                                ? null
                                : () async {
                                    try {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      var paymentIntent =
                                          await createPaymentIntent(
                                              (widget.program.price * 100)
                                                  .toStringAsFixed(0),
                                              'TRY');

                                      await Stripe.instance
                                          .initPaymentSheet(
                                              paymentSheetParameters:
                                                  SetupPaymentSheetParameters(
                                                      paymentIntentClientSecret:
                                                          paymentIntent![
                                                              'client_secret'], //Gotten from payment intent
                                                      style: ThemeMode.light,
                                                      merchantDisplayName:
                                                          'Gymly'))
                                          .then((value) {});

                                      displayPaymentSheet();
                                    } catch (err) {
                                      throw Exception(err);
                                    }
                                  }),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                user?.enrolledProgram == null
                                    ? "Enroll to Program"
                                    : "You are already enrolled to another program",
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    if (widget.cancelMode)
                      ElevatedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Icon(
                                          Icons.warning_amber,
                                          color: Colors.amber,
                                          size: 100.0,
                                        ),
                                        const SizedBox(height: 10.0),
                                        const Text(
                                          "Are you sure?",
                                          style: TextStyle(fontSize: 24),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 10.0),
                                        const Text(
                                          "We have no money refund policy in customer initiated cancelation requests",
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
                                                  "No",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  final isCanceled = await ref
                                                      .read(workoutProvider
                                                          .notifier)
                                                      .cancelUserEnrollment();
                                                  if (isCanceled) {
                                                    ref
                                                        .read(userProvider
                                                            .notifier)
                                                        .getUser();
                                                    Navigator.of(context)
                                                        .popUntil(
                                                            ModalRoute.withName(
                                                      HomePage.routeName,
                                                    ));
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                child: const Text(
                                                  "Yes",
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
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "Cancel your subscription",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
