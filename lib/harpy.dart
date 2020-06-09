import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// [GetIt] is a simple service locator for accessing services from anywhere
/// in the app.
final GetIt app = GetIt.instance;

/// Runs the app with the given [flavor].
///
/// To app can be build with the 'free' or 'pro' flavor by running
/// `flutter build --flavor free -t lib/main_free.dart` or
/// `flutter build --flavor pro -t lib/main_pro.dart`.
void runHarpy(Flavor flavor) {
  Harpy.flavor = flavor;

  runApp(Harpy());
}

class Harpy extends StatelessWidget {
  static Flavor flavor;

  static bool get isFree => flavor == Flavor.free;
  static bool get isPro => flavor == Flavor.pro;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Harpy",
      home: Container(),
    );
  }
}

enum Flavor {
  free,
  pro,
}
