import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileImage extends StatelessWidget {
  final String? imageUrl;
  ProfileImage(this.imageUrl, {super.key});

  final resourceUrl = dotenv.env["RESOURCE_URL"];

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
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
            child: (imageUrl == null || imageUrl!.isEmpty)
                ? Image.asset(
                    "assets/images/1.jpg",
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    "$resourceUrl/$imageUrl",
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
