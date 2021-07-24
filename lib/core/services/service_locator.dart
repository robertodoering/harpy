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
    ..registerLazySingleton(() => HarpyNavigator())
    ..registerLazySingleton(() => HarpyInfo())
    ..registerLazySingleton(() => ChangelogParser())
    ..registerLazySingleton(() => MessageService())
    ..registerLazySingleton(() => TranslationService())
    ..registerLazySingleton(() => ConnectivityService())
    ..registerLazySingleton(() => DownloadService())
    ..registerLazySingleton(() => MediaUploadService())
    ..registerLazySingleton(() => MediaVideoConverter())

    // preferences
    ..registerLazySingleton(() => HarpyPreferences())
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
}
