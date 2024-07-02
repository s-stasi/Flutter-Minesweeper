import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:minesweeper/services/game/game_service.dart';

class MineCell extends ChangeNotifier {
  bool _hasBomb;
  bool _isCovered;
  bool _isFlagged;
  int _adjacentBombs;
  int _index;

  MineCell({
    required bool hasBomb,
    required int index,
    bool isCovered = true,
    bool isFlagged = false,
    int adjacentBombs = 0,
  })  : _hasBomb = hasBomb,
        _isCovered = isCovered,
        _isFlagged = isFlagged,
        _adjacentBombs = adjacentBombs,
        _index = index;

  bool get hasBomb => _hasBomb;
  bool get isCovered => _isCovered;
  bool get isFlagged => _isFlagged;
  int get adjacentBombs => _adjacentBombs;
  int get index => _index;

  void uncover() {
    if (_isCovered) {
      _isCovered = false;
      notifyListeners();
    }
  }

  void uiUncover(MineField field) {
    field.uncoverCell(_index);
  }

  void toggleFlag() {
    _isFlagged = !_isFlagged;
    notifyListeners();
  }

  void setAdjacentBombs(int count) {
    _adjacentBombs = count;
    notifyListeners();
  }

  @override
  String toString() {
    if (_isCovered) {
      return _isFlagged ? 'F' : '.';
    }
    return _hasBomb ? 'X' : _adjacentBombs.toString();
  }
}

class MineField {
  List<MineCell> field;
  int x;
  int y;

  MineField({required this.field, required this.x, required this.y});

  static MineField? generate(GameSettings settings) {
    final rng = Random();
    final mineFieldSquare = settings.rows * settings.columns;
    final field = List<MineCell>.generate(
        mineFieldSquare, (index) => MineCell(hasBomb: false, index: index));
    final coords = List.generate(mineFieldSquare, (i) => i);
    coords.shuffle(rng);
    for (int i = 0; i < settings.bombs; i++) {
      if (coords.isEmpty) {
        return null;
      }
      final coord = coords.removeAt(rng.nextInt(coords.length));
      field[coord] = MineCell(hasBomb: true, index: coord);
    }

    MineField mineField =
        MineField(field: field, x: settings.rows, y: settings.columns);
    mineField.calculateAdjacentBombs();
    return mineField;
  }

  void calculateAdjacentBombs() {
    final directions = [-1, 1, -x, x, -x - 1, -x + 1, x - 1, x + 1];

    for (int i = 0; i < field.length; i++) {
      if (field[i].hasBomb) continue;

      int adjacentBombs = 0;
      for (var dir in directions) {
        int neighborIndex = i + dir;
        if (neighborIndex >= 0 &&
            neighborIndex < field.length &&
            !(i % x == 0 && dir == -1) && // Left edge case
            !(i % x == x - 1 && dir == 1) && // Right edge case
            !(i % x == 0 && dir == -x - 1) && // Top-left edge case
            !(i % x == x - 1 && dir == -x + 1) && // Top-right edge case
            !(i % x == 0 && dir == x - 1) && // Bottom-left edge case
            !(i % x == x - 1 && dir == x + 1)) {
          // Bottom-right edge case
          if (field[neighborIndex].hasBomb) {
            adjacentBombs++;
          }
        }
      }
      field[i].setAdjacentBombs(adjacentBombs);
    }
  }

  void uncoverCell(int index) {
    if (index < 0 || index >= field.length || !field[index].isCovered) return;
    field[index].uncover();
    if (field[index].adjacentBombs == 0 && !field[index].hasBomb) {
      final directions = [-1, 1, -x, x, -x - 1, -x + 1, x - 1, x + 1];
      for (var dir in directions) {
        int neighborIndex = index + dir;
        if (neighborIndex >= 0 &&
            neighborIndex < field.length &&
            !(index % x == 0 && dir == -1) &&
            !(index % x == x - 1 && dir == 1) &&
            !(index % x == 0 && dir == -x - 1) &&
            !(index % x == x - 1 && dir == -x + 1) &&
            !(index % x == 0 && dir == x - 1) &&
            !(index % x == x - 1 && dir == x + 1)) {
          uncoverCell(neighborIndex);
        }
      }
    }
  }

  @override
  String toString() {
    final result = StringBuffer();
    for (int y = 0; y < this.y; y++) {
      for (int x = 0; x < this.x; x++) {
        final coord = x + y * this.x;
        result.write(field[coord].toString());
      }
      result.writeln();
    }
    return result.toString();
  }
}
