import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/core/filesystem/directory_service.dart';
import 'package:harpy/core/initialization/async_initializer.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:harpy/core/utils/logger.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:yaml/yaml.dart';

class ApplicationModel extends Model {
  ApplicationModel({
    @required this.directoryService,
  }) : assert(directoryService != null) {
    _initialize();
  }

  final DirectoryService directoryService;

  static ApplicationModel of(BuildContext context) {
    return ScopedModel.of<ApplicationModel>(context);
  }

  static final Logger _log = Logger("ApplicationModel");

  /// Whether or not the [ApplicationModel] has been initialized.
  bool initialized = false;

  /// The [twitterSession] contains information about the logged in user.
  ///
  /// If the user is not logged in [twitterSession] will be null.
  TwitterSession twitterSession;

  /// The [twitterLogin] is used to log in and out with the native twitter sdk.
  TwitterLogin twitterLogin;

  /// Returns true when the user has logged in with the native twitter sdk.
  ///
  /// Always false if [initialized] is also false.
  bool get loggedIn => twitterSession != null;

  /// A callback that is called when the [ApplicationModel] finished
  /// initializing.
  VoidCallback onInitialized;

  Future<void> _initialize() async {
    initLogger();

    _log.fine("initializing");

    // async initializations
    List<AsyncTask> tasks = [
      // init config
      _initTwitterSession,

      // harpy shared preferences
      HarpyPrefs().init,

      // directory service
      directoryService.init,
    ];

    await AsyncInitializer(tasks).run();

    initialized = true;
    if (onInitialized != null) {
      onInitialized();
    }
  }

  Future<void> _initTwitterSession() async {
    _log.fine("parsing app config");
    String appConfig = await rootBundle.loadString(
      "app_config.yaml",
      cache: false,
    );

    // parse app config
    YamlMap yamlMap = loadYaml(appConfig);
    String consumerKey = yamlMap["twitter"]["consumerKey"];
    String consumerSecret = yamlMap["twitter"]["consumerSecret"];

    // init twitter login
    twitterLogin = TwitterLogin(
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
    );

    // init active twitter session
    twitterSession = await twitterLogin.currentSession;
  }
}
