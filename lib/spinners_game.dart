// ignore_for_file: slash_for_doc_comments

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spinners/utils.dart';

class SpinnersGame extends StatelessWidget {
  static const String title = 'Spinner game';

  const SpinnersGame({super.key});

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
    super.key,
    required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class Player {
  static const on = true;
  static const off = false;
}

class SequenceActionsClass {
  late int x;
  late int y;
}
// const List<String> gameDifficulty = <String>[
//   'I\'m too young to die',
//   'Hey, not too rough',
//   'Hurt me plenty',
//   'Ultra-Violence',
//   'Nightmare!',
// ];

enum GameDifficulty { easy, medium, hard }

extension ParseToString on GameDifficulty {
  String toShortString() {
    return toString().split('.').last;
  }
}

class _MainPageState extends State<MainPage> {
  late int countMatrix = 3;
  //late int ;
  static const double size = 92;
  late GameDifficulty lastDifficulty;
  bool lastMove = Player.off;
  late List<List<bool>> matrix;
  late List<SequenceActionsClass> sequenceActions = [];

  @override
  void initState() {
    super.initState();
    startSession(GameDifficulty.easy);
  }

  // Timer scheduleTimeout([int milliseconds = 10000]) {
  //   return Timer(Duration(milliseconds: milliseconds), displayAToolTip);
  // }

  void setDifficulty(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        countMatrix = 3;
        setEmptyFields();
        randomizeMatrix(3);
        break;
      case GameDifficulty.medium:
        countMatrix = 4;
        setEmptyFields();
        randomizeMatrix(6);
        break;
      case GameDifficulty.hard:
        countMatrix = 5;
        setEmptyFields();
        randomizeMatrix(9);
        break;
    }
  }

  void displayAToolTip() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          giveTheMove(),
        ),
      ),
    );
  }

  void startSession(GameDifficulty difficulty) {
    lastDifficulty = difficulty;
    setDifficulty(difficulty);
  }

  String giveTheMove() {
    var testMatrix = matrix;
    // var mirrorMatrix = matrix;
    var numberSteps = 0;
    // var colorChoose = false;
    SequenceActionsClass sequenceActionsClassRed = SequenceActionsClass();
    SequenceActionsClass sequenceActionsClassBlue = SequenceActionsClass();
    // List<SequenceActionsClass> reversedList =
    //     List.from(sequenceActions.reversed);
    // return "Next move: [${reversedList.first.x}, ${reversedList.first.y}]";
    // if (colorChoice == Player.on) {
    // } else if (colorChoice == Player.off) {}

    // for (var i = 0; i < countMatrix; i++) {
    //   for (var j = 0; j < countMatrix; j++) {
    //     matrix[i][j].
    //   }
    // }
    for (var spinnerVariants = 0; spinnerVariants < 2; spinnerVariants++) {
      // var prevNumberSteps = numberSteps;

      final newValue = lastMove == Player.on ? Player.off : Player.on;
      var sequence =
          newValue ? sequenceActionsClassRed : sequenceActionsClassBlue;

      for (numberSteps = 0; numberSteps < countMatrix; numberSteps++) {
        sequence.x = numberSteps;
        var index = matrix[numberSteps].indexOf(newValue);
        if (index != -1) {
          sequence.y = index;
        }
        print("${numberSteps} ${index}");
        sequenceActions.add(sequence);
      }

      // if (prevNumberSteps < numberSteps) {
      //   colorChoose = newValue;
      // } else {
      //   (colorChoose = newValue == Player.on ? Player.off : Player.on);
      // }
    }
    print(sequenceActions.length);

    for (var element in sequenceActions) {
      print("${element.x} ${element.y}");
      if (selectField(element.x, element.y, testMatrix, true)) {
        return "Найдено";
      }
    }
    return "Найдено";
  }

  void randomizeMatrix(int shuffleCount) {
    for (var i = 0; i < shuffleCount; i++) {
      var x = Random().nextInt(countMatrix);
      var y = Random().nextInt(countMatrix);
      selectField(x, y, matrix, true);

      // SequenceActionsClass sequenceActionsClass = SequenceActionsClass();
      // sequenceActionsClass.x = x;
      // sequenceActionsClass.y = y;
      // sequenceActions.add(sequenceActionsClass);
    }
    if (isEnd()) {
      randomizeMatrix(shuffleCount);
    }

    //matrix[i][j] = Random().nextBool();
  }

  void setEmptyFields() => setState(() => matrix = List.generate(
        countMatrix,
        (_) => List.generate(countMatrix, (_) => Player.off),
      ));

  Color getBackgroundColor() {
    final thisMove = lastMove == Player.on ? Player.off : Player.on;

    return getFieldColor(thisMove).withAlpha(150);
  }

  @override
  Widget build(BuildContext context) {
    // const TextStyle(color: Colors.blue),
    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            displayAToolTip();
          },
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.restart_alt),
          onPressed: () {
            startSession(lastDifficulty);
          },
        ),
        actions: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 18),
            child: Text(
              'Difficulty:',
              textAlign: TextAlign.center,
              selectionColor: Colors.black,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              value: lastDifficulty,
              icon: const Padding(
                padding: EdgeInsets.only(top: 5, right: 10),
                child: Icon(Icons.arrow_downward),
              ),
              elevation: 18,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              dropdownColor: Colors.blue,
              items:
                  GameDifficulty.values.map<DropdownMenuItem<GameDifficulty>>(
                (GameDifficulty value) {
                  return DropdownMenuItem<GameDifficulty>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, left: 10),
                      child: Text(
                        value.toShortString(),
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
              onChanged: (GameDifficulty? value) {
                // This is called when the user selects an item.
                // startSession(value!);
                // Navigator.of(context).pop();
                setState(() => startSession(value!));
              },
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: Utils.modelBuilder(matrix, (x, value) => buildRow(x)),
      ),
    );
  }

//  actions: [
//             ElevatedButton(
//               onPressed: () {
//                 startSession();
//                 Navigator.of(context).pop();
//               },
//               child: Text('Restart'),
//             )
//           ],

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
            Image.asset('assets/images/spinner.png', width: 70, height: 100));
  }

  Widget buildField(int x, int y) {
    final value = matrix[x][y];
    final color = getFieldColor(value);

    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(size, size),
          backgroundColor: color,
        ),
        child: getSprite(value),
        onPressed: () => selectField(x, y, matrix),
      ),
    );
  }

  /**
   * 
   */
  bool selectField(int x, int y, List<List<bool>> inpMatrix,
      [bool randomize = false]) {
    // SequenceActionsClass sequenceActionsClass = SequenceActionsClass();
    // sequenceActionsClass.x = x;
    // sequenceActionsClass.y = y;
    // sequenceActions.add(sequenceActionsClass);

    final newValue = lastMove == Player.on ? Player.off : Player.on;

    setState(() {
      lastMove = newValue;

      for (var i = 0; i < countMatrix; i++) {
        for (var j = 0; j < countMatrix; j++) {
          if (i == x || j == y) {
            if (inpMatrix[i][j] == newValue) {
              inpMatrix[i][j] = newValue == Player.on ? Player.off : Player.on;
              continue;
            }
            inpMatrix[i][j] = newValue;
          }
        }
        //matrix[i][i] = newValue;
      }
      //matrix[x][y] = newValue;
    });
    if (!randomize) {
      if (isEnd()) {
        showEndDialog('You won!');
        return true;
      }
    } else if (randomize) {
      if (isEnd()) {
        return true;
      }
    }
    return false;
    // if (isWinner(x, y)) {
    //   showEndDialog('Player $newValue Won');
    // } else if (isEnd()) {
    //   showEndDialog('Undecided Game');
    // }
    //  }
  }

  bool isEnd() {
    if (matrix
            .every((values) => values.every((value) => value == Player.off)) ||
        matrix.every((values) => values.every((value) => value == Player.on))) {
      return true;
    }
    return false;
  }

  // bool isWinner(int x, int y) {
  //   var col = 0, row = 0, diag = 0, rdiag = 0;
  //   final player = matrix[x][y];
  //   final n = countMatrix;

  //   for (int i = 0; i < n; i++) {
  //     if (matrix[x][i] == player) col++;
  //     if (matrix[i][y] == player) row++;
  //     if (matrix[i][i] == player) diag++;
  //     if (matrix[i][n - i - 1] == player) rdiag++;
  //   }

  //   return row == n || col == n || diag == n || rdiag == n;
  // }

  Future showEndDialog(String title) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text('Press to Restart the Game'),
          actions: [
            ElevatedButton(
              onPressed: () {
                startSession(lastDifficulty);
                Navigator.of(context).pop();
              },
              child: Text('Restart'),
            )
          ],
        ),
      );
}
