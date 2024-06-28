import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minesweeper/screen/home_page/home_screen.dart';
import 'package:minesweeper/services/settings.dart';
import 'package:minesweeper/widgets/custom_appbar.dart';

class UsernameScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();

  UsernameScreen({super.key});

  void _submitUsername(BuildContext context) {
    final String username = _usernameController.text;
    if (username.isNotEmpty) {
      log('Submitted Username: $username');

      // Save the new username
      GetIt.I<Settings>().setUsername = username;

      // Navigate to home page and remove previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Enter Username',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
              onSubmitted: (username) => _submitUsername(context),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitUsername(context),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
