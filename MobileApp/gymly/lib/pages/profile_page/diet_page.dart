import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/models/appuser.dart';
import 'package:gymly/pages/home_page.dart';
import 'package:gymly/pages/posts_page/posts_page.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/user_provider.dart';

class DietPage extends ConsumerStatefulWidget {
  static const routeName = "/DietPage";
  const DietPage({super.key});

  @override
  DietPageState createState() => DietPageState();
}

class DietPageState extends ConsumerState<DietPage> {
  final _formKey = GlobalKey<FormState>();

  String diet = "";

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
      appBar: AppBar(title: const Text("Gymly")),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 100),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const SizedBox(height: 200),
                const Center(
                  child: Text(
                    "Your Diet",
                    style: TextStyle(fontSize: 32),
                  ),
                ),
                // const SizedBox(height: 100),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 400,
                        child: TextFormField(
                          onSaved: (newValue) {
                            diet = newValue ?? "";
                          },
                          initialValue: user == null ? "" : user.diet,
                          maxLines: 20,
                          minLines: 20,
                          style: const TextStyle(fontSize: 20),
                          decoration: buildDecoration("Diet", ""),
                          keyboardType: TextInputType.multiline,
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
                // const SizedBox(height: 200),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final isUpdated = await ref
                          .read(userProvider.notifier)
                          .updateDiet(diet);

                      if (isUpdated) {
                        ref.read(userProvider.notifier).getUser();
                        Navigator.of(context).pop(true);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
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
      ),
    );
  }
}
