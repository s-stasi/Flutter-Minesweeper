import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minesweeper/screen/home_page/minesweeper_widget.dart';
import 'package:minesweeper/services/settings.dart';
import 'package:minesweeper/widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: GetIt.I<Settings>().username.value,
        showDifficultyDropdown: true,
      ),
      body: const MinesweeperScreen(),
    );
  }
}
