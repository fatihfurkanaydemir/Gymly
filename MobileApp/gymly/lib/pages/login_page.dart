import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/constants/colors.dart';
import 'package:gymly/pages/home_page.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/user_provider.dart';
import 'package:video_player/video_player.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const routeName = '/LoginPage';

  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final VideoPlayerController _videoController =
      VideoPlayerController.asset('assets/videos/login_background.mp4');
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _videoController.initialize().then((_) {
      _videoController.play();
      _videoController.setLooping(true);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          ),
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.96),
                  Colors.black,
                  Colors.black,
                ],
                stops: const [0.0, 0.5, 0.78, 0.82, 1.0],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.grey.withOpacity(0.01),
              alignment: Alignment.center,
            ),
          ),
          Column(children: <Widget>[
            const Spacer(flex: 10),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        disabledBackgroundColor: primaryDarkColor),
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                            });
                            final loginSuccess =
                                await ref.read(authProvider.notifier).login();

                            if (!loginSuccess) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text('LOGIN OR SIGNUP',
                            style: TextStyle(
                                color: textColorWhite,
                                letterSpacing: 2,
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ]),
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  "Are you a trainer?",
                  style: TextStyle(color: textColorWhite, fontSize: 15),
                ),
              ),
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 10,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color: textColorGrey2),
                          ),
                          const Spacer(flex: 1),
                          const Text('[AYARLAR ANTRENÖRLÜK]'),
                          const Spacer(flex: 1),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  child: const Text('OKAY'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const Spacer(flex: 1),
          ])
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }
}
