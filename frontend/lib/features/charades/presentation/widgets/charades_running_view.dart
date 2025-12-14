import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/charades_bloc.dart';
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
  late AnimationController _flashController;
  late Animation<double> _flashOpacity;
  Color _flashColor = Colors.transparent;

  @override
  void initState() {
    super.initState();

    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _flashOpacity = Tween<double>(
      begin: 0,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _flashController, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant CharadesRunningView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Detect result change
    if (widget.state.lastResult != oldWidget.state.lastResult) {
      if (widget.state.lastResult == CharadesResult.correct) {
        _triggerFlash(const Color(0xFF26890C)); // green
      } else if (widget.state.lastResult == CharadesResult.skipped) {
        _triggerFlash(const Color(0xFFE21B3C)); // red
      }
    }
  }

  void _triggerFlash(Color color) async {
    setState(() => _flashColor = color);
    await _flashController.forward(from: 0);
    await _flashController.reverse();
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
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
              ],
            ),
          ),

          // FLASH OVERLAY
          IgnorePointer(
            child: FadeTransition(
              opacity: _flashOpacity,
              child: Container(color: _flashColor),
            ),
          ),
        ],
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
