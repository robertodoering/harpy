import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

/// Builds the root [MaterialApp].
class Harpy extends StatelessWidget {
  static const bool isFree =
      String.fromEnvironment('flavor', defaultValue: 'free') == 'free';
  static const bool isPro = String.fromEnvironment('flavor') == 'pro';

  @override
  Widget build(BuildContext context) {
    final themeBloc = context.watch<ThemeBloc>();

    return MaterialApp(
      title: 'Harpy',
      theme: themeBloc.state.lightHarpyTheme.themeData,
      darkTheme: themeBloc.state.darkHarpyTheme.themeData,
      color: Colors.black,
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
      builder: (context, child) => _ContentBuilder(child: child!),
    );
  }
}

class _ContentBuilder extends StatelessWidget {
  const _ContentBuilder({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final systemBrightness = MediaQuery.platformBrightnessOf(context);

    return ProxyProvider<ThemeBloc, HarpyTheme>(
      update: (_, themeBloc, __) => systemBrightness == Brightness.light
          ? themeBloc.state.lightHarpyTheme
          : themeBloc.state.darkHarpyTheme,
      child: ScrollConfiguration(
        behavior: const HarpyScrollBehavior(),
        child: HarpyMessage(
          child: child,
        ),
      ),
    );
  }
}
