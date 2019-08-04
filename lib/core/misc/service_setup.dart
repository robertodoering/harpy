import 'package:harpy/api/translate/translate_service.dart';
import 'package:harpy/api/twitter/services/media_service.dart';
import 'package:harpy/api/twitter/services/tweet_search_service.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/core/cache/home_timeline_cache.dart';
import 'package:harpy/core/cache/user_cache.dart';
import 'package:harpy/core/cache/user_timeline_cache.dart';
import 'package:harpy/core/misc/connectivity_service.dart';
import 'package:harpy/core/misc/directory_service.dart';
import 'package:harpy/core/misc/flushbar_service.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:harpy/harpy.dart';

void setupServices() {
  app
    // twitter services
    ..registerLazySingleton<TwitterClient>(() => TwitterClient())
    ..registerLazySingleton<TweetService>(() => TweetService())
    ..registerLazySingleton<TweetSearchService>(() => TweetSearchService())
    ..registerLazySingleton<MediaService>(() => MediaService())
    ..registerLazySingleton<UserService>(() => UserService())

    // cache
    ..registerLazySingleton<HomeTimelineCache>(() => HomeTimelineCache())
    ..registerLazySingleton<UserTimelineCache>(() => UserTimelineCache())
    ..registerLazySingleton<UserCache>(() => UserCache())

    // custom / util
    ..registerLazySingleton<DirectoryService>(() => DirectoryService())
    ..registerLazySingleton<TranslationService>(() => TranslationService())
    ..registerLazySingleton<ConnectivityService>(() => ConnectivityService())
    ..registerLazySingleton<HarpyPrefs>(() => HarpyPrefs())
    ..registerLazySingleton<FlushbarService>(() => FlushbarService());
}
