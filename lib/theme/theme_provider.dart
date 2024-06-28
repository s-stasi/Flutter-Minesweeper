import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minesweeper/services/settings.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  bool _isDarkMode;

  ThemeProvider({bool isDarkMode = true})
      : _isDarkMode = isDarkMode,
        _themeData = isDarkMode ? _darkTheme : _lightTheme {
    // get accent color from settings when the app is starting
    _setAccentColor(GetIt.I<Settings>().accentColor.value);

    GetIt.I<Settings>().accentColor.addListener(() {
      _setAccentColor(GetIt.I<Settings>().accentColor.value);
    });
  }

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _themeData = _isDarkMode ? _darkTheme : _lightTheme;
    _setAccentColor(GetIt.I<Settings>()
        .accentColor
        .value); // Ensure the accent color is set after theme toggling
    notifyListeners();
  }

  void _setAccentColor(Color color) {
    if (_isDarkMode) {
      _themeData = _darkTheme.copyWith(
        colorScheme: _darkTheme.colorScheme.copyWith(secondary: color),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: _darkTheme.textTheme.apply(
          bodyColor: color,
          displayColor: color,
        ),
        iconTheme: IconThemeData(color: color),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: color),
          titleTextStyle: TextStyle(color: color, fontSize: 20),
        ),
      );
    } else {
      _themeData = _lightTheme.copyWith(
        colorScheme: _lightTheme.colorScheme.copyWith(secondary: color),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: _lightTheme.textTheme.apply(
          bodyColor: color,
          displayColor: color,
        ),
        iconTheme: IconThemeData(color: color),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: color),
          titleTextStyle: TextStyle(color: color, fontSize: 20),
        ),
      );
    }
    notifyListeners();
  }

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    colorScheme: ColorScheme.dark(
      primary: Colors.blueGrey,
      secondary: Colors.blueGrey[700]!,
      background: Colors.black,
      surface: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    iconTheme: IconThemeData(color: Colors.blueGrey[700]!),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.blueGrey[700]!),
      titleTextStyle: TextStyle(color: Colors.blueGrey[700]!, fontSize: 20),
    ),
  );

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blue[700]!,
      background: Colors.white,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    iconTheme: IconThemeData(color: Colors.blue[700]!),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.blue[700]!),
      titleTextStyle: TextStyle(color: Colors.blue[700]!, fontSize: 20),
    ),
  );
}
