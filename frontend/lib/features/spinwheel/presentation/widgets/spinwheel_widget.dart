import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:audioplayers/audioplayers.dart';

class SpinwheelWidget extends StatefulWidget {
  final List<String> items;
  final Stream<int> selectedStream;
  final VoidCallback onAnimationEnd;

  const SpinwheelWidget({
    super.key,
    required this.items,
    required this.selectedStream,
    required this.onAnimationEnd,
  });

  static const List<Color> _palette = [
    Color(0xFFE21B3C),
    Color(0xFFFFA602),
    Color(0xFF26890C),
    Color(0xFF1368CE),
    Color(0xFF46178F),
  ];

  @override
  State<SpinwheelWidget> createState() => _SpinwheelWidgetState();
}

class _SpinwheelWidgetState extends State<SpinwheelWidget> {
  late AudioPlayer _player;
  StreamSubscription<int>? _sub;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();

    // listen stream: ketika selected berubah, mulai spin
    _sub = widget.selectedStream.listen((_) async {
      await _player.stop();
      await _player.play(AssetSource("audio/spin.wav"));
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;

    if (items.isEmpty) {
      return Center(
        child: Stack(
          children: [
            Container(
              width: 450,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/icon/clock_time.gif",
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 10),
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: const Text(
                      "Tambahkan item\nterlebih dahulu",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (items.length == 1) {
      return AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE21B3C),
                ),
                alignment: Alignment.center,
                child: Text(
                  items.first,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FortuneWheel(
            selected: widget.selectedStream,
            animateFirst: false,
            rotationCount: 6,
            physics: CircularPanPhysics(
              duration: const Duration(milliseconds: 4500),
            ),

            /// STOP audio saat animasi selesai
            onAnimationEnd: () async {
              await _player.stop();
              widget.onAnimationEnd();
            },

            items: [
              for (int i = 0; i < items.length; i++)
                FortuneItem(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 8),
                    child: Text(
                      items[i],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  style: FortuneItemStyle(
                    color: SpinwheelWidget._palette[i %
                        SpinwheelWidget._palette.length],
                    borderColor: Colors.white,
                    borderWidth: 2,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
