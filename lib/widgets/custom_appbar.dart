import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get_it/get_it.dart';
import 'package:minesweeper/hive_adapters/difficulty.dart';
import 'package:minesweeper/services/settings.dart';
import 'package:minesweeper/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? showDifficultyDropdown;
  const CustomAppbar(
      {super.key, required this.title, this.showDifficultyDropdown})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  void _showColorPicker(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    Color pickerColor = themeProvider.themeData.colorScheme.secondary;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick an Accent Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                pickerColor = color;
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Select'),
              onPressed: () {
                GetIt.I<Settings>().setAccentColor = pickerColor;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(children: [
        if (showDifficultyDropdown != null && showDifficultyDropdown!)
          DropdownButton<Difficulty>(
            value: GetIt.I<Settings>().difficulty.value,
            items: Difficulty.values
                .map((difficulty) => DropdownMenuItem<Difficulty>(
                      value: difficulty,
                      child: Text(difficulty.description),
                    ))
                .toList(),
            onChanged: (value) {
              GetIt.I<Settings>().changeDifficulty(value);
            },
          ),
        Text(title),
      ]),
      actions: [
        IconButton(
          icon: const Icon(Icons.brightness_6),
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
        ),
        IconButton(
          icon: const Icon(Icons.color_lens),
          onPressed: () {
            _showColorPicker(context);
          },
        ),
      ],
    );
  }
}
