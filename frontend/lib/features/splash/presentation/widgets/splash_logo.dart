import 'package:flutter/material.dart';

class SplashLogo extends StatelessWidget {
  final double opacity;
  final double scale;

  const SplashLogo({
    super.key,
    required this.opacity,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Image.asset(
          "assets/logo/clinter_logo_v1.png",
          width: 170,
          height: 170,
        ),
      ),
    );
  }
}
