import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:minesweeper/hive_adapters/difficulty.dart';
import 'package:minesweeper/services/game/grid.dart';
import 'package:minesweeper/services/settings.dart';

class GameSettings {
  final int _rows;
  final int _columns;
  final int _bombs;

  GameSettings(this._rows, this._columns, this._bombs);

  int get rows => _rows;
  int get columns => _columns;
  int get bombs => _bombs;
}

class GameService {
  static Map<Difficulty, GameSettings> gameSettings = {
    Difficulty.easy: GameSettings(9, 9, 10),
    Difficulty.medium: GameSettings(16, 16, 40),
    Difficulty.hard: GameSettings(28, 28, 157),
  };

  late ValueNotifier<MineField> field;

  GameService() {
    // add listener for changing difficulty
    GetIt.I<Settings>().difficulty.addListener(() {
      field.value = MineField.generate(
          gameSettings[GetIt.I<Settings>().difficulty.value]!)!;
    });

    field = ValueNotifier<MineField>(MineField.generate(
        gameSettings[GetIt.I<Settings>().difficulty.value]!)!);
  }
}
