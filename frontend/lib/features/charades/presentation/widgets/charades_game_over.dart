import 'package:flutter/material.dart';

class CharadesGameOverWidget extends StatelessWidget {
  final int score;
  final List<Color> palette;
  final VoidCallback onRestart;

  const CharadesGameOverWidget({
    super.key,
    required this.score,
    required this.palette,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 680,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: palette[0].withOpacity(0.08), blurRadius: 18),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Game Over!',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w800,
                color: palette[0],
              ),
            ),
            const SizedBox(height: 10),
            const Text('Your Score', style: TextStyle(fontSize: 18)),
            Text(
              '$score',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w800,
                color: palette[3],
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRestart,
              style: ElevatedButton.styleFrom(
                backgroundColor: palette[3],
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
              ),
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
