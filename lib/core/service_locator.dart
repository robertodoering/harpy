import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get_it/get_it.dart';
import 'package:harpy/core/analytics_service.dart';
import 'package:harpy/core/api/translate/translate_service.dart';
import 'package:harpy/core/app_config.dart';
import 'package:harpy/core/connectivity_service.dart';
import 'package:harpy/core/error_reporter.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/preferences/harpy_preferences.dart';
import 'package:harpy/core/preferences/media_preferences.dart';
import 'package:harpy/core/preferences/setup_preferences.dart';
import 'package:harpy/core/preferences/theme_preferences.dart';
import 'package:harpy/misc/harpy_navigator.dart';

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
    ..registerLazySingleton<ErrorReporter>(() => ErrorReporter())
    ..registerLazySingleton<AppConfig>(() => AppConfig())
    ..registerLazySingleton<MessageService>(() => MessageService())
    ..registerLazySingleton<TranslationService>(() => TranslationService())
    ..registerLazySingleton<ConnectivityService>(() => ConnectivityService())
    ..registerLazySingleton<AnalyticsService>(() => AnalyticsService())

    // preferences
    ..registerLazySingleton<HarpyPreferences>(() => HarpyPreferences())
    ..registerLazySingleton<MediaPreferences>(() => MediaPreferences())
    ..registerLazySingleton<ThemePreferences>(() => ThemePreferences())
    ..registerLazySingleton<SetupPreferences>(() => SetupPreferences());
}
