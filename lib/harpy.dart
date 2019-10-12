import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:harpy/components/screens/entry_screen.dart';
import 'package:harpy/core/misc/harpy_error_handler.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/core/misc/service_setup.dart';
import 'package:harpy/models/global_models_provider.dart';
import 'package:harpy/models/settings/settings_models_provider.dart';

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

  setupServices();

  // HarpyErrorHandler will run the app and handle uncaught errors
  HarpyErrorHandler(
    child: SettingsModelsProvider(
      child: GlobalModelsProvider(
        child: Harpy(),
      ),
    ),
  );
}

class Harpy extends StatelessWidget {
  static Flavor flavor;

  static bool get isFree => flavor == Flavor.free;
  static bool get isPro => flavor == Flavor.pro;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Harpy",
      theme: HarpyTheme.of(context).theme,
      navigatorKey: HarpyNavigator.key,
      home: EntryScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum Flavor {
  free,
  pro,
}
