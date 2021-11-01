import 'dart:io';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'data.dart';
import 'http_overrides.dart';
import 'mocks.dart';

/// Used for common test initialization.
Future<void> setupApp() async {
  HttpOverrides.global = MockHttpOverrides();
  VisibilityDetectorController.instance.updateInterval = Duration.zero;

  app
    ..registerLazySingleton<TwitterApi>(() => MockTwitterApi())
    ..registerLazySingleton<HarpyNavigator>(() => MockHarpyNavigator())
    ..registerLazySingleton<MessageService>(() => MockMessageService())
    ..registerLazySingleton<HarpyInfo>(() => MockHarpyInfo())
    ..registerLazySingleton<TranslationService>(() => MockTranslationService())
    ..registerLazySingleton<ConnectivityService>(
      () => MockConnectivityService(),
    )
    // preferences
    ..registerLazySingleton<HarpyPreferences>(() => MockHarpyPreferences())
    ..registerLazySingleton(() => const AuthPreferences())
    ..registerLazySingleton(() => const MediaPreferences())
    ..registerLazySingleton(() => const ThemePreferences())
    ..registerLazySingleton(() => const SetupPreferences())
    ..registerLazySingleton(() => const LayoutPreferences())
    ..registerLazySingleton(() => const ChangelogPreferences())
    ..registerLazySingleton(() => const GeneralPreferences())
    ..registerLazySingleton(() => const LanguagePreferences())
    ..registerLazySingleton(() => const TweetVisibilityPreferences())
    ..registerLazySingleton(() => const TimelineFilterPreferences())
    ..registerLazySingleton(() => const HomeTabPreferences())
    ..registerLazySingleton(() => const TrendsPreferences());

  await app<HarpyPreferences>().initialize();
}

/// Wraps the [child] with a [MaterialApp] and mocked global providers for
/// widget tests.
Widget buildAppBase(
  Widget child, {
  HomeTimelineState? homeTimelineState,
  MentionsTimelineState mentionsTimelineState = const MentionsTimelineInitial(),
}) {
  return _MockGlobalProviders(
    homeTimelineState: homeTimelineState ?? _defaultHomeTimelineState,
    mentionsTimelineState: mentionsTimelineState,
    builder: (context) {
      final themeBloc = context.watch<ThemeBloc>();
      final systemBrightness = context.watch<Brightness>();

      return MaterialApp(
        home: child,
        debugShowCheckedModeBanner: false,
        theme: themeBloc.state.lightHarpyTheme.themeData,
        darkTheme: themeBloc.state.darkHarpyTheme.themeData,
        themeMode: systemBrightness == Brightness.light
            ? ThemeMode.light
            : ThemeMode.dark,
        locale: const Locale('en'),
        builder: (_, child) => HarpyThemeProvider(
          child: ScrollConfiguration(
            behavior: const HarpyScrollBehavior(),
            child: HarpyScaffold(body: child!),
          ),
        ),
      );
    },
  );
}

/// Wraps the [child] in a [ListView] before building the app base.
Widget buildAppListBase(
  Widget child, {
  HomeTimelineState? homeTimelineState,
  MentionsTimelineState mentionsTimelineState = const MentionsTimelineInitial(),
}) {
  return buildAppBase(
    ListView(
      children: [child],
    ),
    homeTimelineState: homeTimelineState,
    mentionsTimelineState: mentionsTimelineState,
  );
}

class _MockGlobalProviders extends StatelessWidget {
  const _MockGlobalProviders({
    required this.builder,
    required this.homeTimelineState,
    required this.mentionsTimelineState,
  });

  final WidgetBuilder builder;
  final HomeTimelineState homeTimelineState;
  final MentionsTimelineState mentionsTimelineState;

  @override
  Widget build(BuildContext context) {
    return SystemBrightnessObserver(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ConfigCubit()),
          BlocProvider(
            create: (context) => ThemeBloc(
              configCubit: context.read<ConfigCubit>(),
            ),
          ),
          BlocProvider<HomeTimelineBloc>(
            create: (_) => MockHomeTimelineBloc(homeTimelineState),
          ),
          BlocProvider<MentionsTimelineBloc>(
            create: (_) => MockMentionsTimelineBloc(mentionsTimelineState),
          ),
        ],
        child: Builder(builder: builder),
      ),
    );
  }
}

final _defaultHomeTimelineState = HomeTimelineResult(
  maxId: '',
  newTweets: 0,
  timelineFilter: TimelineFilter.empty,
  tweets: exampleTweetList,
);
