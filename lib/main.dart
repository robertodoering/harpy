import 'package:flutter/material.dart';
import 'package:harpy/components/screens/main_screen.dart';
import 'package:logging/logging.dart';

void main() {
  // Setup Logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print(
        '${rec.level.name} :: ${rec.loggerName} :: ${rec.time} :: ${rec.message}');
  });

  runApp(MaterialApp(
    title: "Harpy",
    home: MainScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
