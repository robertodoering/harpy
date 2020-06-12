import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:harpy/components/screens/entry_screen.dart';
import 'package:harpy/components/widgets/shared/harpy_banner_ad.dart';
import 'package:harpy/core/misc/harpy_error_handler.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/core/misc/route_observer.dart';
import 'package:harpy/core/misc/service_setup.dart';
import 'package:harpy/models/global_models_provider.dart';
import 'package:harpy/models/settings/settings_models_provider.dart';

/// [GetIt] is a simple service locator for accessing services from anywhere
/// in the app.
final GetIt app = GetIt.instance;

/// Used for firebase analytics.
final FirebaseAnalytics analytics = FirebaseAnalytics();

/// Runs the app with the given [flavor].
///
/// To app can be run with the 'free' or 'pro' flavor by running
/// `flutter run --flavor free -t lib/main_free.dart` or
/// `flutter run --flavor pro -t lib/main_pro.dart`.
void runHarpy(Flavor flavor) {
  Harpy.flavor = flavor;

  setupServices();

  // WidgetsFlutterBinding.ensureInitialized();
  // analytics.logAppOpen();

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
      debugShowCheckedModeBanner: false,
      title: "Harpy",
      theme: HarpyTheme.of(context).theme,
      navigatorKey: HarpyNavigator.key,
      onGenerateRoute: onGenerateRoute,
      navigatorObservers: [routeObserver],
      home: EntryScreen(),
      builder: _builder,
    );
  }

  /// Builds the content for the app.
  ///
  /// The [child] is the screen pushed by the navigator.
  Widget _builder(BuildContext context, Widget child) {
    if (isFree) {
      // add space at the bottom occupied by a banner ad in Harpy free
      return Column(
        children: <Widget>[
          Expanded(child: child),
          HarpyBannerAd(),
        ],
      );
    } else {
      return child;
    }
  }
}

enum Flavor {
  free,
  pro,
}
