import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get_it/get_it.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/core/preferences/home_tab_preferences.dart';
import 'package:harpy/misc/misc.dart';

/// [GetIt] is a simple service locator for accessing services from anywhere
/// in the app.
final GetIt app = GetIt.instance;

/// Adds the services to the [app] service locator.
void setupServices() {
  app
    ..registerLazySingleton<TwitterApi>(
      () => TwitterApi(
        client: TwitterClient(
          consumerKey: '',
          consumerSecret: '',
          token: '',
          secret: '',
        ),
      ),
    )
    ..registerLazySingleton(() => const AppConfig())
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
