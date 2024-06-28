import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minesweeper/services/settings.dart';
import 'package:minesweeper/start_app.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // Initialize widgets bindings
  WidgetsFlutterBinding.ensureInitialized;

  // Initialize hive boxes
  if (kIsWeb) {
    await Hive.initFlutter();
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await Hive.initFlutter('minesweeper');
  } else {
    await Hive.initFlutter();
  }

  // Open boxes
  await openHiveBox('settings', limit: true);

  startServices();

  // Start app
  runApp(const StartApp());
}

/// Starts services
Future<void> startServices() async {
  GetIt.I.registerSingleton<Settings>(Settings());
}

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  Box box = await Hive.openBox(boxName).onError((error, stackTrace) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    File dbFile = File('$dirPath/$boxName.hive');
    File lockFile = File('$dirPath/$boxName.lock');
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dbFile = File('$dirPath/minesweeper/$boxName.hive');
      lockFile = File('$dirPath/minesweeper/$boxName.lock');
    }
    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);
    throw 'Failed to open $boxName Box\nError: $error';
  });

  // clear box if it grows large
  if (limit && box.length > 500) {
    box.clear();
  }
}
