import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/pages/home_page.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/user_provider.dart';

class BodyMeasurementsPage extends ConsumerStatefulWidget {
  static const routeName = "/BodyMeasurementsPage";
  const BodyMeasurementsPage({super.key});

  @override
  BodyMeasurementsPageState createState() => BodyMeasurementsPageState();
}

class BodyMeasurementsPageState extends ConsumerState<BodyMeasurementsPage> {
  final _formKey = GlobalKey<FormState>();

  double weight = 0;
  double height = 0;

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
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Gymly")),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(children: [
          const SizedBox(height: 100),
          const Center(
            child: Text(
              "Your Measurements",
              style: TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(height: 100),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 80,
                  child: TextFormField(
                    onSaved: (newValue) {
                      weight = double.tryParse(newValue ?? "") ?? 0;
                    },
                    expands: true,
                    initialValue: user == null
                        ? ""
                        : (user.weight == 0 ? "" : user.weight.toString()),
                    maxLines: null,
                    minLines: null,
                    style: const TextStyle(fontSize: 26),
                    decoration: buildDecoration("Weight", "kg"),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 80,
                  child: TextFormField(
                    onSaved: (newValue) {
                      height = double.tryParse(newValue ?? "") ?? 0;
                    },
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    initialValue: user == null
                        ? ""
                        : (user.height == 0 ? "" : user.height.toString()),
                    style: const TextStyle(fontSize: 26),
                    decoration: buildDecoration("Height", "cm"),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 200),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                final isUpdated = await ref
                    .read(userProvider.notifier)
                    .updateMeasurements(weight, height);

                if (isUpdated) {
                  ref.read(userProvider.notifier).getUser();
                  Navigator.of(context).pop(true);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.save,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(width: 15),
                Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
