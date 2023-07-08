import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The app can be built with the 'free' or 'pro' flavor by running
/// `flutter run --flavor free --dart-define=flavor=free` or
/// `flutter run --flavor pro --dart-define=flavor=pro` respectively.
///
/// Additionally a twitter api key is required for authentication and can be
/// specified using
/// `--dart-define=twitter_consumer_key=your_consumer_key` and
/// `--dart-define=twitter_consumer_secret=your_consumer_secret`.
Future<void> main() async {
  // ErrorHandler will run the app and handle uncaught errors
  ErrorHandler(
    builder: () async {
      WidgetsFlutterBinding.ensureInitialized();
      final sharedPreferences = await SharedPreferences.getInstance();

      // pre-cache flare animations
      FlareCache.doesPrune = false;
      await warmupFlare();

      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        observers: [ProviderLogger()],
        child: const HarpyApp(),
      );
    },
  );
}

class HarpyApp extends ConsumerWidget {
  const HarpyApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'harpy',
      color: ref.watch(platformBrightnessProvider) == Brightness.light
          ? Colors.white
          : Colors.black,
      theme: ref.watch(lightThemeProvider).themeData,
      darkTheme: ref.watch(darkThemeProvider).themeData,
      themeMode: ref.watch(platformBrightnessProvider) == Brightness.light
          ? ThemeMode.light
          : ThemeMode.dark,
      supportedLocales: [
        ...WidgetsBinding.instance.platformDispatcher.locales,
        const Locale('en' 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routeInformationProvider:
          ref.watch(routerProvider).routeInformationProvider,
      routeInformationParser: ref.watch(routerProvider).routeInformationParser,
      routerDelegate: ref.watch(routerProvider).routerDelegate,
      builder: (_, child) => AnnotatedRegion(
        value: ref.watch(harpyThemeProvider).colors.systemUiOverlayStyle,
        child: SystemGesturePlaceholder(
          child: Unfocus(child: child),
        ),
      ),
    );
  }
}
