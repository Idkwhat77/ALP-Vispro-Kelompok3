import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/charades_bloc.dart';
import '../bloc/charades_event.dart';
import '../bloc/charades_state.dart';

class CharadesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CharadesBloc()..add(StartGame()),
      child: Scaffold(
        appBar: AppBar(title: Text("Gyro Charades")),
        body: BlocBuilder<CharadesBloc, CharadesState>(
          builder: (context, state) {
            if (state is CharadesRunning) {
              return Center(
                child: Text(state.currentWord, style: TextStyle(fontSize: 40)),
              );
            } else if (state is CharadesGameOver) {
              return Center(
                child: Text(
                  "Game Over! Score: ${state.score}",
                  style: TextStyle(fontSize: 30),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
