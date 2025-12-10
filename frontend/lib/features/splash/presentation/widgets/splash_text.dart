import 'package:flutter/material.dart';

class SplashText extends StatelessWidget {
  final double opacity;

  const SplashText({
    super.key,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: const Text(
        "CLINTER",
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: Colors.black,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
