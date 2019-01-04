import 'package:harpy/core/config/app_configuration.dart';
import 'package:harpy/core/filesystem/directory_service.dart';
import 'package:harpy/core/initialization/async_initializer.dart';
import 'package:harpy/core/log/logger.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:harpy/stores/tokens.dart';
import 'package:logging/logging.dart';

final Logger log = Logger("AppInitialization");

Future<void> initializeApp() async {
  log.fine("initializing app");

  // init logger
  initLogger();

  // init store tokens
  Tokens();

  // async initializations
  List<AsyncTask> tasks = [
    // harpy shared preferences
    HarpyPrefs().init,

    // directory service
    DirectoryService().init,

    // app config
    AppConfiguration().init,
  ];

  await AsyncInitializer(tasks).run();
}
