import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';

import 'mocks.dart';

Future<void> setupApp() async {
  app
    ..registerLazySingleton<TwitterApi>(() => MockTwitterApi())
    ..registerLazySingleton<HarpyNavigator>(() => MockHarpyNavigator())
    ..registerLazySingleton<MessageService>(() => MockMessageService())
    // preferences
    ..registerLazySingleton<HarpyPreferences>(() => MockHarpyPreferences())
    ..registerLazySingleton(() => AuthPreferences())
    ..registerLazySingleton(() => MediaPreferences())
    ..registerLazySingleton(() => ThemePreferences())
    ..registerLazySingleton(() => SetupPreferences())
    ..registerLazySingleton(() => LayoutPreferences())
    ..registerLazySingleton(() => ChangelogPreferences())
    ..registerLazySingleton(() => GeneralPreferences())
    ..registerLazySingleton(() => LanguagePreferences())
    ..registerLazySingleton(() => TweetVisibilityPreferences())
    ..registerLazySingleton(() => TimelineFilterPreferences())
    ..registerLazySingleton(() => HomeTabPreferences())
    ..registerLazySingleton(() => TrendsPreferences());

  await app<HarpyPreferences>().initialize();
}
