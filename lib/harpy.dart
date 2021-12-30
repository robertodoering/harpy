import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

const isFree = String.fromEnvironment('flavor', defaultValue: 'free') == 'free';
const isPro = String.fromEnvironment('flavor') == 'pro';

/// Builds the root [MaterialApp].
class Harpy extends StatelessWidget {
  const Harpy();

  @override
  Widget build(BuildContext context) {
    final themeBloc = context.watch<ThemeBloc>();
    final systemBrightness = context.watch<Brightness>();

    return MaterialApp(
      title: 'harpy',
      theme: themeBloc.state.lightHarpyTheme.themeData,
      darkTheme: themeBloc.state.darkHarpyTheme.themeData,
      themeMode: systemBrightness == Brightness.light
          ? ThemeMode.light
          : ThemeMode.dark,
      color: Colors.black,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: kMaterialSupportedLanguages.map(Locale.new),
      navigatorKey: app<HarpyNavigator>().key,
      onGenerateRoute: onGenerateRoute,
      navigatorObservers: [
        harpyRouteObserver,
      ],
      home: const SplashScreen(),
      builder: (_, child) => _ContentBuilder(child: child),
    );
  }
}

class _ContentBuilder extends StatelessWidget {
  const _ContentBuilder({
    required this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return HarpyThemeProvider(
      child: ScrollConfiguration(
        behavior: const HarpyScrollBehavior(),
        child: HarpyMessage(
          child: child,
        ),
      ),
    );
  }
}
