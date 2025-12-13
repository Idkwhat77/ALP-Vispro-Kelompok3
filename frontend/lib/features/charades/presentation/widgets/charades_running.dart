import 'package:flutter/material.dart';
import 'word_card.dart';

class CharadesRunningWidget extends StatelessWidget {
  final String currentWord;
  final int score;
  final int remaining;
  final Animation<double> scale;
  final Animation<double> fade;
  final List<Color> palette;

  const CharadesRunningWidget({
    super.key,
    required this.currentWord,
    required this.score,
    required this.remaining,
    required this.scale,
    required this.fade,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                palette[4].withOpacity(0.12),
                palette[3].withOpacity(0.08),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Center(
          child: WordCard(
            word: currentWord,
            scale: scale,
            fade: fade,
            palette: palette,
          ),
        ),
        Positioned(
          left: 20,
          top: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: palette[1].withOpacity(0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Score: $score',
              style: TextStyle(fontWeight: FontWeight.bold, color: palette[1]),
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: palette[2].withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Remaining: $remaining',
              style: TextStyle(fontWeight: FontWeight.bold, color: palette[2]),
            ),
          ),
        ),
      ],
    );
  }
}
