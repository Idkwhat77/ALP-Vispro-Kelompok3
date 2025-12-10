import 'dart:math';
import 'package:flutter/material.dart';

class DotParticle extends StatefulWidget {
  final Offset startOffset;

  const DotParticle({super.key, required this.startOffset});

  @override
  State<DotParticle> createState() => _DotParticleState();
}

class _DotParticleState extends State<DotParticle>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _radius;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  final List<Color> particleColors = const [
    Color(0xFFE21B3C), // red
    Color(0xFFFFA602), // yellow
    Color(0xFF26890C), // green
    Color(0xFF1368CE), // blue
  ];

  late Color chosenColor;

  @override
  void initState() {
    super.initState();

    chosenColor = particleColors[Random().nextInt(particleColors.length)];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _radius = Tween<double>(begin: 0, end: 28).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _opacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _offset = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(
        (Random().nextDouble() - 0.5) * 24,
        (Random().nextDouble() - 0.5) * 24,
      ),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Positioned(
          left: widget.startOffset.dx + _offset.value.dx - _radius.value / 2,
          top: widget.startOffset.dy + _offset.value.dy - _radius.value / 2,
          child: Opacity(
            opacity: _opacity.value,
            child: Container(
              width: _radius.value,
              height: _radius.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: chosenColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
