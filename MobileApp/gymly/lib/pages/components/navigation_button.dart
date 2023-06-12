import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const NavigationButton(this.text, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          const Icon(
            Icons.chevron_right,
            size: 40,
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
