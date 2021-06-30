import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';

/// Builds the root [MaterialApp].
class Harpy extends StatelessWidget {
  static const bool isFree =
      String.fromEnvironment('flavor', defaultValue: 'free') == 'free';
  static const bool isPro = String.fromEnvironment('flavor') == 'pro';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) => MaterialApp(
        title: 'Harpy',
        theme: ThemeBloc.of(context).harpyTheme.data,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: kMaterialSupportedLanguages.map(
          (languageCode) => Locale(languageCode),
        ),
        navigatorKey: app<HarpyNavigator>().key,
        onGenerateRoute: onGenerateRoute,
        navigatorObservers: <NavigatorObserver>[
          FirebaseAnalyticsObserver(
            analytics: app<AnalyticsService>().analytics,
            nameExtractor: screenNameExtractor,
          ),
          harpyRouteObserver,
        ],
        home: const SplashScreen(),
        builder: (_, child) => ScrollConfiguration(
          behavior: const HarpyScrollBehavior(),
          child: HarpyMessage(
            child: child,
          ),
        ),
      ),
    );
  }
}
