import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minesweeper/screen/home_page/home_screen.dart';
import 'package:minesweeper/screen/initialize/username_screen.dart';
import 'package:minesweeper/services/settings.dart';
import 'package:minesweeper/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: GetIt.I<Settings>().needsInitialization
              ? UsernameScreen()
              : const HomeScreen(),
        ),
      ),
    );
  }
}
