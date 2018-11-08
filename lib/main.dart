import 'package:flutter/material.dart';
import 'package:harpy/components/screens/main_screen.dart';
import 'package:harpy/core/app_configuration.dart';
import 'package:harpy/stores/login_store.dart';

void main() async {
  await AppConfiguration().init();

  // initialize stores
  loginStoreToken;
  runApp(MaterialApp(
    title: "Harpy",
    home: MainScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
