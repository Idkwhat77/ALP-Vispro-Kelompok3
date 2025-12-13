import 'package:flutter/material.dart';

class WordCard extends StatelessWidget {
  final String word;
  final Animation<double> scale;
  final Animation<double> fade;
  final List<Color> palette;

  const WordCard({
    super.key,
    required this.word,
    required this.scale,
    required this.fade,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: FadeTransition(
        opacity: fade,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: palette[0].withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            word,
            maxLines: 5,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.w700,
              color: palette[4], // purple
            ),
          ),
        ),
      ),
    );
  }
}
