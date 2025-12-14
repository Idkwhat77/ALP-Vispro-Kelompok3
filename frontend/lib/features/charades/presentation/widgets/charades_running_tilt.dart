import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'word_card.dart';

class CharadesRunningTiltWidget extends StatefulWidget {
  final String currentWord;
  final int score;
  final int remaining;
  final Animation<double> scale;
  final Animation<double> fade;
  final List<Color> palette;
  final VoidCallback onGuess;
  final VoidCallback onSkip;

  const CharadesRunningTiltWidget({
    super.key,
    required this.currentWord,
    required this.score,
    required this.remaining,
    required this.scale,
    required this.fade,
    required this.palette,
    required this.onGuess,
    required this.onSkip,
  });

  @override
  State<CharadesRunningTiltWidget> createState() =>
      _CharadesRunningTiltWidgetState();
}

class _CharadesRunningTiltWidgetState extends State<CharadesRunningTiltWidget> {
  double _tiltX = 0; // left-right
  double _tiltY = 0; // up-down

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((event) {
      setState(() {
        _tiltX = event.y; // landscape left-right
        _tiltY = event.x; // landscape up-down
      });

      // left tilt -> guess
      if (_tiltX > 3) widget.onGuess();
      // right tilt -> skip
      if (_tiltX < -3) widget.onSkip();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.palette[4].withOpacity(0.12),
                widget.palette[3].withOpacity(0.08),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Center(
          child: WordCard(
            word: widget.currentWord,
            scale: widget.scale,
            fade: widget.fade,
            palette: widget.palette,
          ),
        ),
        Positioned(
          left: 20,
          top: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: widget.palette[1].withOpacity(0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Score: ${widget.score}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.palette[1],
              ),
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: widget.palette[2].withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Remaining: ${widget.remaining}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.palette[2],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
