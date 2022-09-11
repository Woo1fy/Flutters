import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spinners/spinners_game.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(SpinnersGame());
}
