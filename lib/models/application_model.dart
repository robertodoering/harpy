import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/core/cache/home_timeline_cache.dart';
import 'package:harpy/core/cache/user_timeline_cache.dart';
import 'package:harpy/core/misc/async_initializer.dart';
import 'package:harpy/core/misc/connectivity_service.dart';
import 'package:harpy/core/misc/directory_service.dart';
import 'package:harpy/core/misc/logger.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:yaml/yaml.dart';

/// The [ApplicationModel] handles initialization in the [EntryScreen] when
/// starting the app.
class ApplicationModel extends Model {
  ApplicationModel({
    @required this.directoryService,
    @required this.homeTimelineCache,
    @required this.userTimelineCache,
    @required this.twitterClient,
    @required this.harpyPrefs,
    @required this.connectivityService,
    @required this.themeSettingsModel,
  })  : assert(directoryService != null),
        assert(homeTimelineCache != null),
        assert(userTimelineCache != null),
        assert(twitterClient != null),
        assert(harpyPrefs != null),
        assert(connectivityService != null),
        assert(themeSettingsModel != null) {
    _initialize();
  }

  final DirectoryService directoryService;
  final HomeTimelineCache homeTimelineCache;
  final UserTimelineCache userTimelineCache;
  final TwitterClient twitterClient;
  final HarpyPrefs harpyPrefs;
  final ConnectivityService connectivityService;
  final ThemeSettingsModel themeSettingsModel;

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

    // set application model references
    twitterClient.applicationModel = this;
    harpyPrefs.applicationModel = this;

    // async initializations
    await AsyncInitializer(<AsyncTask>[
      // init config
      _initTwitterSession,

      // harpy shared preferences
      harpyPrefs.init,

      // directory service
      directoryService.init,

      // init connectivity status
      connectivityService.init
    ]).run();

    if (loggedIn) {
      initLoggedIn();
    }

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

  /// Called when initializing and already logged in or in the [LoginModel]
  /// after logging in for the first time.
  void initLoggedIn() {
    // init theme from shared prefs
    themeSettingsModel.initTheme();

    // init tweet cache logged in user
    userTimelineCache.initLoggedInUser(twitterSession.userId);
    homeTimelineCache.initLoggedInUser(twitterSession.userId);
  }
}
