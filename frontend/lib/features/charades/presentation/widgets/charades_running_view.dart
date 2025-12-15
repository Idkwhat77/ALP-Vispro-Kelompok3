import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/charades_bloc.dart';
import '../../blocs/charades_event.dart';
import '../../blocs/charades_state.dart';

class CharadesRunningView extends StatefulWidget {
  final CharadesRunning state;
  final Animation<double> scale;
  final Animation<double> fade;

  const CharadesRunningView({
    super.key,
    required this.state,
    required this.scale,
    required this.fade,
  });

  @override
  State<CharadesRunningView> createState() => _CharadesRunningViewState();
}

class _CharadesRunningViewState extends State<CharadesRunningView>
    with SingleTickerProviderStateMixin {
  late AnimationController _timerController;
  Color? _flashColor;

  static const Duration _roundDuration = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();

    _timerController = AnimationController(
      vsync: this,
      duration: _roundDuration,
    )..forward();
  }

  @override
  void didUpdateWidget(covariant CharadesRunningView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.state.currentWord != widget.state.currentWord) {
      _timerController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _flashColor ?? Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              _TopBar(
                score: widget.state.score,
                remaining: widget.state.remaining,
              ),

              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: widget.fade,
                    child: ScaleTransition(
                      scale: widget.scale,
                      child: _WordCard(word: widget.state.currentWord),
                    ),
                  ),
                ),
              ),

              _TimerBar(controller: _timerController),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int score;
  final int remaining;

  const _TopBar({required this.score, required this.remaining});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatChip(
            label: "Skor",
            value: score.toString(),
            color: const Color(0xFF26890C), // green
          ),
          _StatChip(
            label: "Sisa Kata",
            value: remaining.toString(),
            color: const Color(0xFFFFA602), // yellow
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WORD CARD
// ─────────────────────────────────────────────

class _WordCard extends StatelessWidget {
  final String word;

  const _WordCard({required this.word});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 440,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      decoration: BoxDecoration(
        color: const Color(0xFF46178F),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        word.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 42,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TIMER BAR
// ─────────────────────────────────────────────

class _TimerBar extends StatelessWidget {
  final AnimationController controller;

  const _TimerBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          height: 6,
          child: AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              return LinearProgressIndicator(
                value: controller.value,
                backgroundColor: Colors.black12,
                valueColor: const AlwaysStoppedAnimation(Color(0xFFE21B3C)),
              );
            },
          ),
        ),
      ),
    );
  }
}
