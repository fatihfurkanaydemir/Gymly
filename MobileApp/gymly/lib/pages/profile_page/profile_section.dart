import 'package:flutter/material.dart';
import 'package:gymly/constants/colors.dart';
import 'profile_image.dart';

class ProfileSection extends StatelessWidget {
  final String imageUrl;
  final String userName, userEmail;

  const ProfileSection({
    required this.userName,
    required this.userEmail,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        width: double.infinity,
        color: const Color(0xFF252735),
        child: Padding(
          padding: const EdgeInsets.only(top: 30) +
              const EdgeInsets.symmetric(
                horizontal: 20,
              ),
          child: Column(
            children: <Widget>[
              const ProfileImage(),
              const SizedBox(
                height: 20,
              ),
              Text(
                userName,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: textColorWhite),
              ),
              const SizedBox(height: 10),
              Text(
                userEmail,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: textColorWhite),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
