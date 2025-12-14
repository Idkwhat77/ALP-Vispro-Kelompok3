import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/charades_bloc.dart';
import '../../blocs/charades_event.dart';
import '../../blocs/charades_state.dart';

class CharadesRunningView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(score: state.score, remaining: state.remaining),

            Expanded(
              child: Center(
                child: FadeTransition(
                  opacity: fade,
                  child: ScaleTransition(
                    scale: scale,
                    child: _WordCard(word: state.currentWord),
                  ),
                ),
              ),
            ),

            _BottomControls(),
          ],
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
          _StatChip(label: "Score", value: score.toString()),
          _StatChip(label: "Remaining", value: remaining.toString()),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WORD CARD (CENTER STAGE)
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
// BOTTOM CONTROLS (THUMB ZONE)
// ─────────────────────────────────────────────

class _BottomControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              label: "PASS",
              color: const Color(0xFFE21B3C),
              onTap: () => context.read<CharadesBloc>().add(
                TiltUpdated(PhoneTilt.awayFromFace),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              label: "CORRECT",
              color: const Color(0xFF26890C),
              onTap: () => context.read<CharadesBloc>().add(
                TiltUpdated(PhoneTilt.towardFace),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
