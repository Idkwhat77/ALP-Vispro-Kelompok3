import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class CharadesRunningTiltWidget extends StatefulWidget {
  final String currentWord;
  final int score;
  final int remaining;
  final List<Color> palette;
  final void Function(String direction) onTilt; // left/right

  const CharadesRunningTiltWidget({
    super.key,
    required this.currentWord,
    required this.score,
    required this.remaining,
    required this.palette,
    required this.onTilt,
  });

  @override
  State<CharadesRunningTiltWidget> createState() =>
      _CharadesRunningTiltWidgetState();
}

class _CharadesRunningTiltWidgetState extends State<CharadesRunningTiltWidget> {
  DeviceOrientation _orientation = DeviceOrientation.landscapeLeft;
  double _tilt = 0;

  @override
  void initState() {
    super.initState();
    // Start listening to accelerometer
    accelerometerEvents.listen((event) {
      double x = event.x;
      double y = event.y;

      double tilt;

      // Adjust axis mapping based on forced landscape orientation
      if (_orientation == DeviceOrientation.landscapeLeft) {
        tilt = y; // tilting left/right affects y in landscapeLeft
      } else {
        tilt = -y; // invert for landscapeRight
      }

      setState(() {
        _tilt = tilt;
      });

      // Call the callback for left/right detection
      if (tilt > 1) {
        widget.onTilt("right");
      } else if (tilt < -1) {
        widget.onTilt("left");
      }
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: widget.palette[0].withOpacity(0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.currentWord,
              maxLines: 5,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w700,
                color: widget.palette[4],
              ),
            ),
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
        Positioned(
          bottom: 20,
          left: 20,
          child: Text(
            'Tilt value: ${_tilt.toStringAsFixed(2)}',
            style: TextStyle(color: widget.palette[0]),
          ),
        ),
      ],
    );
  }
}
