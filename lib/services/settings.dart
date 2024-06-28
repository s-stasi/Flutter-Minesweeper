import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Settings {
  final ValueNotifier<String> username = ValueNotifier<String>('');
  final ValueNotifier<Color> accentColor = ValueNotifier(Colors.blueGrey[700]!);

  static final Box settingsBox = Hive.box('settings');
  bool _needsInitialization = true;

  Settings() {
    _init();
  }

  void _init() {
    // retrieve settings from memory
    username.value = settingsBox.get('username', defaultValue: '');
    accentColor.value =
        settingsBox.get('accentColor', defaultValue: Colors.blueGrey[700]!);

    // check if first access
    _needsInitialization = username.value.isEmpty ? false : true;
  }

  set setUsername(String newUsername) {
    settingsBox.put('username', newUsername);
    username.value = newUsername;
  }

  set setAccentColor(Color newAccentColor) {
    accentColor.value = newAccentColor;
  }

  bool get needsInitialization => _needsInitialization;
}
