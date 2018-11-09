import 'package:flutter/material.dart';
import 'package:harpy/core/log/harpy_logger.dart';
import 'package:harpy/components/screens/main/main_screen.dart';

void main() {
  // Setup Logger
  HarpyLogger().init();

  runApp(MaterialApp(
    title: "Harpy",
    home: MainScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
