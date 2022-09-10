import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'package:spinners/spinners_game.dart';

void main() {
  final game = SpinnersGame();
  runApp(GameWidget(game: game));
}
