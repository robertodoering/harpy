import 'package:flutter/material.dart';
import 'package:harpy/components/screens/main_screen.dart';
import 'package:harpy/core/log/harpy_logger.dart';

void main() {
  // Setup Logger
  HarpyLogger().init();

  runApp(MaterialApp(
    title: "Harpy",
    home: MainScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
