import 'package:get_it/get_it.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// [GetIt] is a simple service locator for accessing services from anywhere
/// in the app.
final GetIt app = GetIt.instance;

/// Adds the services to the [app] service locator.
void setupServices() {
  app.registerLazySingleton<HarpyNavigator>(() => HarpyNavigator());
}
