import 'dart:math';
import 'package:flutter/material.dart';

class SplashParticles extends StatefulWidget {
  final Offset startOffset;

  const SplashParticles({super.key, required this.startOffset});

  @override
  State<SplashParticles> createState() => _SplashParticlesState();
}

class _SplashParticlesState extends State<SplashParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> movement;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    final random = Random();
    final angle = random.nextDouble() * 2 * pi;
    final distance = 40 + random.nextDouble() * 40;

    movement = Tween<Offset>(
      begin: widget.startOffset,
      end: widget.startOffset +
          Offset(cos(angle) * distance, sin(angle) * distance),
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Positioned(
          left: movement.value.dx,
          top: movement.value.dy,
          child: Opacity(
            opacity: 1 - controller.value,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
