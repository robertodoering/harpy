import 'package:flutter/material.dart';
import 'package:harpy/components/screens/main_screen.dart';
import 'package:harpy/core/app_configuration.dart';
import 'package:harpy/stores/login_store.dart';
import 'package:logging/logging.dart';

void main() async {
  // Setup Logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print(
        '${rec.level.name} :: ${rec.loggerName} :: ${rec.time} :: ${rec.message}');
  });

  await AppConfiguration().init();
  // initialize stores
  loginStoreToken;
  runApp(MaterialApp(
    title: "Harpy",
    home: MainScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
