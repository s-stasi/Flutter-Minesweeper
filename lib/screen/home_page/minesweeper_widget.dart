import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minesweeper/services/game/game_service.dart';
import 'package:minesweeper/services/game/grid.dart';
import 'package:provider/provider.dart';

class MinesweeperScreen extends StatelessWidget {
  const MinesweeperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GetIt.I<GameService>().field,
      builder: (context, value, child) {
        return MineFieldWidget(
          mineField: value,
        );
      },
    );
  }
}

class MineFieldWidget extends StatelessWidget {
  final MineField mineField;

  const MineFieldWidget({super.key, required this.mineField});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: mineField.x,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: mineField.field[index],
          child: MineCellWidget(field: mineField),
        );
      },
      itemCount: mineField.field.length,
    );
  }
}

class MineCellWidget extends StatelessWidget {
  final MineField field;
  const MineCellWidget({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    final cell = Provider.of<MineCell>(context);

    return GestureDetector(
      onTap: () {
        field.uncoverCell(cell.index);
      },
      onSecondaryTap: () {
        cell.toggleFlag();
      },
      onLongPress: () {
        cell.toggleFlag();
      },
      child: Container(
        margin: EdgeInsets.all(1.0),
        color: cell.isCovered ? Colors.grey : Colors.white,
        child: Center(
          child: Text(
            cell.isCovered
                ? (cell.isFlagged ? '🚩' : '')
                : (cell.hasBomb ? '💣' : cell.adjacentBombs.toString()),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
