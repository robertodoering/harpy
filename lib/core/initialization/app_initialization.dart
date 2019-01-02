import 'package:harpy/core/config/app_configuration.dart';
import 'package:harpy/core/initialization/async_initializer.dart';
import 'package:harpy/core/log/harpy_logger.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:harpy/stores/tokens.dart';

Future<void> initializeApp() async {
  // init logger
  HarpyLogger.init();

  // init store tokens
  Tokens();

  // async initializations
  List<AsyncTask> tasks = [
    // harpy shared preferences
    HarpyPrefs().init,

    // app config
    AppConfiguration().init,
  ];

  await AsyncInitializer(tasks).run();
}
