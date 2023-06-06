import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/user_provider.dart';

class AddTrainerWorkoutProgram extends ConsumerStatefulWidget {
  static const String routeName = "/AddTrainerWorkoutProgram";

  const AddTrainerWorkoutProgram({super.key});

  @override
  ConsumerState<AddTrainerWorkoutProgram> createState() =>
      _AddTrainerWorkoutProgramState();
}

class _AddTrainerWorkoutProgramState
    extends ConsumerState<AddTrainerWorkoutProgram> {
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String title = "";
  String description = "";
  String programDetails = "";
  double price = 1;
  XFile? _imageFile;

  dynamic _pickImageError;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    if (context.mounted) {
      try {
        final XFile? pickedFile = await _picker.pickImage(
            maxWidth: 5000, maxHeight: 5000, source: ImageSource.gallery);
        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Container(
        width: double.infinity,
        child: Image.file(
          File(_imageFile!.path),
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) =>
                  const Center(child: Text('This image type is not supported')),
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return _buildAddImageButton();
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();

    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Widget _buildAddImageButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("Add Header Image"),
        Icon(Icons.add),
      ],
    );
  }

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
    return Scaffold(
      appBar: AppBar(title: const Text("Add Trainer Program")),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 25),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                      child: TextFormField(
                        onSaved: (newValue) {
                          name = newValue ?? "";
                        },
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        decoration: buildDecoration("Name", ""),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 80,
                      child: TextFormField(
                        onSaved: (newValue) {
                          price = double.tryParse(newValue ?? "") ?? 1;
                        },
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        decoration: buildDecoration("Price", ""),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }
                          double? price = double.tryParse(value);
                          if (price != null && price < 1.0) {
                            return 'Please enter a value greater than 1';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 80,
                      child: TextFormField(
                        onSaved: (newValue) {
                          title = newValue ?? "";
                        },
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        decoration: buildDecoration("Title", ""),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 200,
                      child: TextFormField(
                        onSaved: (newValue) {
                          description = newValue ?? "";
                        },
                        maxLines: 15,
                        minLines: 15,
                        decoration: buildDecoration("Description", ""),
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 300,
                      child: TextFormField(
                        onSaved: (newValue) {
                          programDetails = newValue ?? "";
                        },
                        maxLines: 15,
                        minLines: 15,
                        decoration: buildDecoration("Program details", ""),
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
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  _onImageButtonPressed(
                    ImageSource.gallery,
                    context: context,
                  );
                },
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(5)),
                    child: defaultTargetPlatform == TargetPlatform.android
                        ? FutureBuilder<void>(
                            future: retrieveLostData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<void> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return _previewImages();
                                case ConnectionState.done:
                                  return _previewImages();
                                case ConnectionState.active:
                                  if (snapshot.hasError) {
                                    return Text(
                                      'Pick image/video error: ${snapshot.error}}',
                                      textAlign: TextAlign.center,
                                    );
                                  } else {
                                    return _buildAddImageButton();
                                  }
                              }
                            },
                          )
                        : _previewImages()),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _imageFile != null) {
                          _formKey.currentState!.save();
                          final isAdded = await ref
                              .read(userProvider.notifier)
                              .addTrainerWorkoutProgram(
                                  File(_imageFile!.path),
                                  name,
                                  title,
                                  description,
                                  programDetails,
                                  price);
                          if (isAdded) {
                            ref.read(userProvider.notifier).getUser();
                            Navigator.pop(context);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
