import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spinners/utils.dart';

class SpinnersGame extends StatelessWidget {
  static final String title = 'Spinner game';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class Player {
  static const on = true;
  static const off = false;
}

class _MainPageState extends State<MainPage> {
  static final countMatrix = 6;
  static final double size = 92;

  bool lastMove = Player.off;
  late List<List<bool>> matrix;

  @override
  void initState() {
    super.initState();

    setEmptyFields();
    randomizeMatrix();
  }

  void randomizeMatrix() {
    for (var i = 0; i < countMatrix; i++) {
      for (var j = 0; j < countMatrix; j++) {
        matrix[i][j] = Random().nextBool();
      }
    }
  }

  void setEmptyFields() => setState(() => matrix = List.generate(
        countMatrix,
        (_) => List.generate(countMatrix, (_) => Player.off),
      ));

  Color getBackgroundColor() {
    final thisMove = lastMove == Player.on ? Player.off : Player.on;

    return getFieldColor(thisMove).withAlpha(150);
  }

  final TextEditingController _textFieldController = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New game'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(
                hintText: 'Введите размер матрицы',
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: getBackgroundColor(),
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  foregroundColor: Colors.white),
              onPressed: () => _displayDialog(context),
              child: const Text('Restart'),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: Utils.modelBuilder(matrix, (x, value) => buildRow(x)),
        ),
      );

  Widget buildRow(int x) {
    final values = matrix[x];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(
        values,
        (y, value) => buildField(x, y),
      ),
    );
  }

  Color getFieldColor(bool value) {
    switch (value) {
      case Player.off:
        return Colors.blue;
      case Player.on:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  Transform getSprite(bool value) {
    return Transform(
        alignment: Alignment.center,
        transform: value == Player.on
            ? Matrix4.rotationZ(90 * pi / 180)
            : Matrix4.rotationZ(180 * pi / 180),
        child:
            Image.asset('assets/images/spinner.png', width: 100, height: 100));
  }

  Widget buildField(int x, int y) {
    final value = matrix[x][y];
    final color = getFieldColor(value);

    return Container(
      margin: EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(size, size),
          primary: color,
        ),
        child: getSprite(value),
        onPressed: () => selectField(value, x, y),
      ),
    );
  }

  void selectField(bool value, int x, int y) {
    //  if (value == Player.none) {
    final newValue = lastMove == Player.on ? Player.off : Player.on;

    setState(() {
      lastMove = newValue;

      for (var i = 0; i < countMatrix; i++) {
        for (var j = 0; j < countMatrix; j++) {
          if (i == x || j == y) {
            if (matrix[i][j] == newValue) {
              matrix[i][j] = newValue == Player.on ? Player.off : Player.on;
              continue;
            }
            matrix[i][j] = newValue;
          }
        }
        //matrix[i][i] = newValue;
      }
      //matrix[x][y] = newValue;
    });

    // if (isWinner(x, y)) {
    //   showEndDialog('Player $newValue Won');
    // } else if (isEnd()) {
    //   showEndDialog('Undecided Game');
    // }
    //  }
  }

  bool isEnd() =>
      matrix.every((values) => values.every((value) => value != Player.off));

  /// Check out logic here: https://stackoverflow.com/a/1058804
  bool isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = matrix[x][y];
    final n = countMatrix;

    for (int i = 0; i < n; i++) {
      if (matrix[x][i] == player) col++;
      if (matrix[i][y] == player) row++;
      if (matrix[i][i] == player) diag++;
      if (matrix[i][n - i - 1] == player) rdiag++;
    }

    return row == n || col == n || diag == n || rdiag == n;
  }

  Future showEndDialog(String title) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text('Press to Restart the Game'),
          actions: [
            ElevatedButton(
              onPressed: () {
                setEmptyFields();
                Navigator.of(context).pop();
              },
              child: Text('Restart'),
            )
          ],
        ),
      );
}
