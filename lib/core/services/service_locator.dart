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
          consumerKey: null,
          consumerSecret: null,
          token: null,
          secret: null,
        ),
      ),
    )
    ..registerLazySingleton<HarpyNavigator>(() => HarpyNavigator())
    ..registerLazySingleton<HarpyInfo>(() => HarpyInfo())
    ..registerLazySingleton<ChangelogParser>(() => ChangelogParser())
    ..registerLazySingleton<MessageService>(() => MessageService())
    ..registerLazySingleton<TranslationService>(() => TranslationService())
    ..registerLazySingleton<ConnectivityService>(() => ConnectivityService())
    ..registerLazySingleton<AnalyticsService>(() => AnalyticsService())
    ..registerLazySingleton<DownloadService>(() => DownloadService())
    ..registerLazySingleton<MediaUploadService>(() => MediaUploadService())
    ..registerLazySingleton<MediaVideoConverter>(() => MediaVideoConverter())

    // preferences
    ..registerLazySingleton<HarpyPreferences>(() => HarpyPreferences())
    ..registerLazySingleton<AuthPreferences>(() => AuthPreferences())
    ..registerLazySingleton<MediaPreferences>(() => MediaPreferences())
    ..registerLazySingleton<ThemePreferences>(() => ThemePreferences())
    ..registerLazySingleton<SetupPreferences>(() => SetupPreferences())
    ..registerLazySingleton<LayoutPreferences>(() => LayoutPreferences())
    ..registerLazySingleton<ChangelogPreferences>(() => ChangelogPreferences())
    ..registerLazySingleton<GeneralPreferences>(() => GeneralPreferences())
    ..registerLazySingleton<LanguagePreferences>(() => LanguagePreferences())
    ..registerLazySingleton<TweetVisibilityPreferences>(
        () => TweetVisibilityPreferences())
    ..registerLazySingleton<TimelineFilterPreferences>(
        () => TimelineFilterPreferences())
    ..registerLazySingleton<HomeTabPreferences>(() => HomeTabPreferences());
}
