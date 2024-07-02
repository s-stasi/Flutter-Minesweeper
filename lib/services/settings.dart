import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minesweeper/hive_adapters/difficulty.dart';

class Settings {
  final ValueNotifier<String> username = ValueNotifier<String>('');
  final ValueNotifier<Color> accentColor = ValueNotifier(Colors.blueGrey[700]!);
  final ValueNotifier<Difficulty> difficulty = ValueNotifier(Difficulty.easy);

  static final Box settingsBox = Hive.box('settings');
  bool _needsInitialization = true;

  Settings() {
    _init();
  }

  void _init() {
    // user settings
    username.value = settingsBox.get('username', defaultValue: '');
    accentColor.value = Color(settingsBox.get('accentColor',
        defaultValue: Colors.blueGrey[700]!.value) as int);

    // field settings
    difficulty.value =
        settingsBox.get('difficulty', defaultValue: Difficulty.easy);

    // check if first access
    _needsInitialization = username.value.isEmpty ? true : false;
  }

  set setUsername(String newUsername) {
    settingsBox.put('username', newUsername);
    username.value = newUsername;
  }

  set setAccentColor(Color newAccentColor) {
    settingsBox.put('accentColor', newAccentColor.value);
    accentColor.value = newAccentColor;
  }

  bool get needsInitialization => _needsInitialization;

  void changeDifficulty(Difficulty? value) {
    if (value != null) {
      difficulty.value = value;
      settingsBox.put('difficulty', value);
    }
  }
}
