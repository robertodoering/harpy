import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/global_bloc_provider.dart';
import 'package:harpy/components/common/misc/harpy_message.dart';
import 'package:harpy/components/common/screens/splash_screen.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_bloc.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_state.dart';
import 'package:harpy/core/analytics_service.dart';
import 'package:harpy/core/harpy_error_handler.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:harpy/misc/scroll_behavior.dart';

/// The [Flavor] the app is built in.
enum Flavor {
  free,
  pro,
}

/// Runs the app with the given [flavor].
///
/// The app can be built with the 'free' or 'pro' flavor by running
/// `flutter run --flavor free -t lib/main_free.dart` or
/// `flutter run --flavor pro -t lib/main_pro.dart`.
void runHarpy(Flavor flavor) {
  Harpy.flavor = flavor;

  // sets up the global service locator
  setupServices();

  // HarpyErrorHandler will run the app and handle uncaught errors
  HarpyErrorHandler(
    child: GlobalBlocProvider(
      child: Harpy(),
    ),
  );
}

/// Builds the root [MaterialApp].
class Harpy extends StatelessWidget {
  static Flavor flavor;

  // todo: use compile-time argument for flavors instead of different targets
  static bool get isFree => flavor == Flavor.free;
  static bool get isPro => flavor == Flavor.pro;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (BuildContext context, ThemeState state) => MaterialApp(
        title: 'Harpy',
        theme: ThemeBloc.of(context).harpyTheme.data,
        navigatorKey: app<HarpyNavigator>().key,
        onGenerateRoute: onGenerateRoute,
        navigatorObservers: <NavigatorObserver>[
          FirebaseAnalyticsObserver(
            analytics: app<AnalyticsService>().analytics,
            nameExtractor: screenNameExtractor,
          ),
          app<HarpyNavigator>().routeObserver,
        ],
        home: const SplashScreen(),
        builder: (BuildContext widget, Widget child) => ScrollConfiguration(
          behavior: const HarpyScrollBehavior(),
          child: HarpyMessage(
            child: child,
          ),
        ),
      ),
    );
  }
}
