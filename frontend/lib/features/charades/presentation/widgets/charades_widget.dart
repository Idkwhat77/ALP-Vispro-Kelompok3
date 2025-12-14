import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/charades_bloc.dart';
import '../../blocs/charades_event.dart';
import '../../blocs/charades_state.dart';

import 'charades_idle.dart';
import 'charades_running_view.dart';
import 'charades_game_over.dart';

class CharadesWidget extends StatefulWidget {
  const CharadesWidget({super.key});

  @override
  State<CharadesWidget> createState() => _CharadesWidgetState();
}

class _CharadesWidgetState extends State<CharadesWidget>
    with SingleTickerProviderStateMixin {
  static const List<Color> _palette = [
    Color(0xFFE21B3C), // red
    Color(0xFFFFA602), // yellow
    Color(0xFF26890C), // green
    Color(0xFF1368CE), // blue
    Color(0xFF46178F), // purple
  ];

  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scale = Tween(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fade = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _play() => _controller.forward(from: 0);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharadesBloc, CharadesState>(
      listener: (_, state) async {
        if (state is CharadesRunning) {
          _play();
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        }

        if (state is CharadesGameOver || state is CharadesThemesLoaded) {
          await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        }
      },
      builder: (context, state) {
        if (state is CharadesLoadingThemes || state is CharadesLoadingWords) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CharadesThemesLoaded) {
          return CharadesIdle(
            themes: state.themes,
            palette: _palette, // ✅ FIXED
            onSelect: (id, name) =>
                context.read<CharadesBloc>().add(SelectTheme(id, name)),
          );
        }

        if (state is CharadesThemeSelected) {
          return _StartButton(
            onTap: () => context.read<CharadesBloc>().add(StartGame()),
          );
        }

        if (state is CharadesRunning) {
          return CharadesRunningView(state: state, scale: _scale, fade: _fade);
        }

        if (state is CharadesGameOver) {
          return CharadesGameOverWidget(
            score: state.score,
            onRestart: () => context.read<CharadesBloc>().add(RestartGame()),
          );
        }

        if (state is CharadesError) {
          return Center(child: Text(state.message));
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

class _StartButton extends StatelessWidget {
  final VoidCallback onTap;
  const _StartButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260,
        height: 56,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF46178F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "START GAME",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
