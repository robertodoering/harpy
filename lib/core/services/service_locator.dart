import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get_it/get_it.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/core/preferences/home_tab_preferences.dart';
import 'package:harpy/misc/misc.dart';

final app = GetIt.instance;

/// Adds all globally available services to the service locator.
void setupServices() {
  app
    ..registerLazySingleton<TwitterApi>(
      () => TwitterApi(
        client: TwitterClient(
          // updated in the `AuthenticationCubit`
          consumerKey: '',
          consumerSecret: '',
          token: '',
          secret: '',
        ),
      ),
    )
    ..registerLazySingleton(() => const EnvConfig())
    ..registerLazySingleton(() => HarpyNavigator())
    ..registerLazySingleton(() => HarpyInfo())
    ..registerLazySingleton(() => const ChangelogParser())
    ..registerLazySingleton(() => const MessageService())
    ..registerLazySingleton(() => const TranslationService())
    ..registerLazySingleton(() => ConnectivityService())
    ..registerLazySingleton(() => const DownloadService())
    ..registerLazySingleton(() => const MediaUploadService())
    ..registerLazySingleton(() => MediaVideoConverter())

    // preferences
    ..registerLazySingleton(() => HarpyPreferences())
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
}
