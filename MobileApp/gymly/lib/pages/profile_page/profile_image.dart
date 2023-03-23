import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white60,
      ),
      child: Center(
        child: Transform.scale(
          scale: 0.92,
          child: Container(
            clipBehavior: Clip.hardEdge,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Image.asset(
              "assets/images/1.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
