import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:harpy/components/common/misc/harpy_message.dart';
import 'package:harpy/components/common/screens/splash_screen.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_bloc.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_state.dart';
import 'package:harpy/core/analytics_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:harpy/misc/scroll_behavior.dart';

/// Builds the root [MaterialApp].
class Harpy extends StatelessWidget {
  static const bool isFree =
      String.fromEnvironment('flavor', defaultValue: 'free') == 'free';
  static const bool isPro = String.fromEnvironment('flavor') == 'pro';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (BuildContext context, ThemeState state) => MaterialApp(
        title: 'Harpy',
        theme: ThemeBloc.of(context).harpyTheme.data,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: kMaterialSupportedLanguages.map(
          (String languageCode) => Locale(languageCode),
        ),
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
