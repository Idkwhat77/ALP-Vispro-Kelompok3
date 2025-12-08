import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../widgets/selected_dialog.dart';

void showWinnerDialogWithConfetti({
  required BuildContext context,
  required String name,
  required ConfettiController controller,
}) {

  controller.play();

  Future.microtask(() {
  final player = AudioPlayer();
  player.play(AssetSource('audio/win.wav'));
});

  showDialog(
    context: context,
    builder: (_) => Stack(
      alignment: Alignment.center,
      children: [
        SelectedDialog(name: name),
        ConfettiWidget(
          confettiController: controller,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,

          // single blast
          emissionFrequency: 0,

          // optional spread tuning
          minBlastForce: 10,
          maxBlastForce: 20,
          
          numberOfParticles: 30,
        ),
      ],
    ),
  );
}
