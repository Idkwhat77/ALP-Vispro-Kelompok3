abstract class CharadesState {}

class CharadesInitial extends CharadesState {}

class CharadesRunning extends CharadesState {
  final String currentWord;
  final int score;
  CharadesRunning(this.currentWord, this.score);
}

class CharadesGameOver extends CharadesState {
  final int score;
  CharadesGameOver(this.score);
}
