import 'package:dart_twitter_api/twitter_api.dart';
import 'package:get_it/get_it.dart';
import 'package:harpy/core/app_config.dart';
import 'package:harpy/core/error_reporter.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// [GetIt] is a simple service locator for accessing services from anywhere
/// in the app.
final GetIt app = GetIt.instance;

/// Adds the services to the [app] service locator.
void setupServices() {
  app
    ..registerLazySingleton<HarpyNavigator>(() => HarpyNavigator())
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
    ..registerLazySingleton<HarpyInfo>(() => HarpyInfo())
    ..registerLazySingleton<ErrorReporter>(() => ErrorReporter())
    ..registerLazySingleton<AppConfig>(() => AppConfig());
}
