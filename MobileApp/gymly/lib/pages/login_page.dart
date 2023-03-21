import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:video_player/video_player.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const routeName = '/LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final VideoPlayerController _videoController =
      VideoPlayerController.asset('assets/videos/login_background.mp4');

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
            const Spacer(flex: 8),
            Row(children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(43, 45, 66, 1),
                        minimumSize: const Size.fromHeight(55),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                    child: const Text('LOGIN OR SIGNUP',
                        style: TextStyle(
                            color: Color(0xFFD5D5D5),
                            letterSpacing: 3,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    onPressed: () {
                      ref.read(authProvider.notifier).login();
                    },
                  ),
                ),
              ),
            ]),
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
