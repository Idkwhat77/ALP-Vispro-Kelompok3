import 'package:flutter/material.dart';

class SplashDots extends StatelessWidget {
  final Animation<double> mergeProgress;
  final Animation<double> fadeOut;

  final Color dotColor1;
  final Color dotColor2;
  final Color dotColor3;
  final Color dotColor4;

  const SplashDots({
    super.key,
    required this.mergeProgress,
    required this.fadeOut,
    required this.dotColor1,
    required this.dotColor2,
    required this.dotColor3,
    required this.dotColor4,
  });

  @override
  Widget build(BuildContext context) {
    final base = 65 * (1 - mergeProgress.value);

    return Opacity(
      opacity: fadeOut.value,
      child: Stack(
        children: [
          _dot(Offset(6, -base), dotColor1),
          _dot(Offset(-7, base), dotColor2),
          _dot(Offset(-base, -10), dotColor3),
          _dot(Offset(base, 8), dotColor4),
        ],
      ),
    );
  }

  Widget _dot(Offset offset, Color color) {
    return Transform.translate(
      offset: offset,
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
