import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/charades_bloc.dart';
import '../../blocs/charades_event.dart';
import '../../blocs/charades_state.dart';
import 'charades_idle.dart';
import 'charades_running.dart';
import 'charades_game_over.dart';

class CharadesWidget extends StatefulWidget {
  const CharadesWidget({super.key});

  @override
  State<CharadesWidget> createState() => _CharadesWidgetState();
}

class _CharadesWidgetState extends State<CharadesWidget>
    with SingleTickerProviderStateMixin {
  static const List<Color> _palette = [
    Color(0xFFE21B3C),
    Color(0xFFFFA602),
    Color(0xFF26890C),
    Color(0xFF1368CE),
    Color(0xFF46178F),
  ];

  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _playAnim() => _controller.forward(from: 0);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharadesBloc, CharadesState>(
      listener: (context, state) {
        if (state is CharadesRunning) _playAnim();
      },
      builder: (context, state) {
        if (state is CharadesLoadingThemes) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CharadesThemesLoaded) {
          return CharadesIdle(
            themes: state.themes,
            onSelect: (id, name) {
              context.read<CharadesBloc>().add(SelectTheme(id, name));
            },
            palette: _palette,
          );
        }
        if (state is CharadesThemeSelected) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<CharadesBloc>().add(StartGame());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _palette[3],
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
                ),
              ),
              child: const Text('Start Game'),
            ),
          );
        }
        if (state is CharadesLoadingWords) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CharadesRunning) {
          return CharadesRunningWidget(
            currentWord: state.currentWord,
            score: state.score,
            remaining: state.remaining,
            scale: _scale,
            fade: _fade,
            palette: _palette,
          );
        }
        if (state is CharadesGameOver) {
          return CharadesGameOverWidget(
            score: state.score,
            palette: _palette,
            onRestart: () {
              context.read<CharadesBloc>().add(RestartGame());
            },
          );
        }
        if (state is CharadesError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
