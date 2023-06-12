import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/user_provider.dart';

class ChangeProfilePicutrePage extends ConsumerStatefulWidget {
  static const String routeName = "/ChangeProfilePicutrePage";

  const ChangeProfilePicutrePage({super.key});

  @override
  ConsumerState<ChangeProfilePicutrePage> createState() =>
      _ChangeProfilePicutrePageState();
}

class _ChangeProfilePicutrePageState
    extends ConsumerState<ChangeProfilePicutrePage> {
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
        Text("Select new picture"),
        Icon(Icons.add),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Profile Picture")),
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
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
                      if (_imageFile == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          content: Text("Please select an image first"),
                        ));
                        return;
                      }
                      final success =
                          await ref.read(userProvider.notifier).updateAvatar(
                                File(_imageFile!.path),
                              );
                      if (success) {
                        // ref.read(userProvider.notifier).getUser();
                        Navigator.pop(context);
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
    );
  }
}
