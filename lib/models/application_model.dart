import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/components/screens/entry_screen.dart';
import 'package:harpy/components/screens/home_screen.dart';
import 'package:harpy/components/screens/login_screen.dart';
import 'package:harpy/components/widgets/shared/routes.dart';
import 'package:harpy/core/cache/timeline_database.dart';
import 'package:harpy/core/cache/tweet_database.dart';
import 'package:harpy/core/cache/user_database.dart';
import 'package:harpy/core/misc/connectivity_service.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/core/misc/logger.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:yaml/yaml.dart';

/// The [ApplicationModel] handles initialization when starting the app.
///
/// During initialization, the [EntryScreen] is showing.
///
/// If a user was previously logged in, the app will automatically navigate
/// to the [HomeScreen], otherwise it will navigate to the [LoginScreen].
class ApplicationModel {
  ApplicationModel({
    @required this.themeSettingsModel,
    @required this.loginModel,
  }) {
    _initialize();
  }

  final TwitterClient twitterClient = app<TwitterClient>();
  final HarpyPrefs harpyPrefs = app<HarpyPrefs>();
  final ConnectivityService connectivityService = app<ConnectivityService>();
  final TweetDatabase tweetDatabase = app<TweetDatabase>();
  final TimelineDatabase timelineDatabase = app<TimelineDatabase>();
  final UserDatabase userDatabase = app<UserDatabase>();

  final ThemeSettingsModel themeSettingsModel;
  final LoginModel loginModel;

  static ApplicationModel of(BuildContext context) {
    return Provider.of<ApplicationModel>(context);
  }

  static final Logger _log = Logger("ApplicationModel");

  /// Whether or not the [ApplicationModel] has been initialized.
  bool initialized = false;

  /// The [twitterSession] contains information about the logged in user.
  ///
  /// If the user is not logged in [twitterSession] will be `null`.
  TwitterSession twitterSession;

  /// The [twitterLogin] is used to log in and out with the native twitter sdk.
  TwitterLogin twitterLogin;

  /// Returns `true` when the user has logged in with the native twitter sdk.
  ///
  /// Always `false` if [initialized] is also `false`.
  bool get loggedIn => twitterSession != null;

  Future<void> _initialize() async {
    initLogger();
    _log.fine("initializing");

    // set application model references
    twitterClient.applicationModel = this;
    harpyPrefs.applicationModel = this;
    loginModel.applicationModel = this;

    await Future.wait([
      // parse the app config and init the twitter session
      _initTwitterSession(),

      // init harpy shared preferences
      harpyPrefs.init(),

      // init connectivity status
      connectivityService.init(),
    ]);

    if (loggedIn) {
      await initLoggedIn();
    }

    initialized = true;
    _onInitialized();
  }

  /// Called when the [ApplicationModel] finished initializing and navigates
  /// to the next screen.
  Future<void> _onInitialized() async {
    _log.fine("on initialized");

    if (loggedIn) {
      await loginModel.initBeforeHome();

      if (loginModel.loggedInUser != null) {
        _log.fine("navigating to home screen");
        HarpyNavigator.pushReplacementRoute(FadeRoute(
          builder: (context) => HomeScreen(),
          duration: const Duration(milliseconds: 600),
        ));
      } else {
        // unable to get the logged in user, go back to the login screen
        loginModel.onLoginError();
      }
    } else {
      _log.fine("navigating to login screen");
      HarpyNavigator.pushReplacementRoute(FadeRoute(
        builder: (context) => LoginScreen(),
        duration: const Duration(milliseconds: 600),
      ));
    }
  }

  Future<void> _initTwitterSession() async {
    _log.fine("parsing app config");

    String consumerKey;
    String consumerSecret;

    try {
      final String appConfig = await rootBundle.loadString(
        "assets/config/app_config.yaml",
      );

      // parse app config
      final YamlMap yamlMap = loadYaml(appConfig);
      consumerKey = yamlMap["twitter"]["consumer_key"];
      consumerSecret = yamlMap["twitter"]["consumer_secret"];

      if (consumerKey.isEmpty || consumerSecret.isEmpty) {
        throw Exception("Twitter api key or secret is empty.");
      }
    } catch (e, stacktrace) {
      _log.severe(
        "Error while loading app_config.yaml\n"
        "Make sure an 'app_config.yaml' file exists in the 'assets/config/' "
        "directory with the twitter api key and secret.\n"
        "example:\n"
        "app_config.yaml:\n"
        "twitter:\n"
        "    consumer_key: <key>\n"
        "    consumer_secret: <secret>",
        e,
        stacktrace,
      );

      return;
    }

    // init twitter login
    twitterLogin = TwitterLogin(
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
    );

    // init active twitter session
    twitterSession = await twitterLogin.currentSession;

    _log.fine("init twitter session done");
  }

  /// Called when starting the app and the user was previously logged in or
  /// in the [LoginModel] after logging in for the first time.
  Future<void> initLoggedIn() async {
    _log.fine("init logged in");

    // init theme from shared prefs
    themeSettingsModel.initTheme();

    // init databases
    await Future.wait([
      tweetDatabase.initialize(subDirectory: twitterSession.userId),
      timelineDatabase.initialize(subDirectory: twitterSession.userId),
      userDatabase.initialize(subDirectory: twitterSession.userId),
    ]);
  }
}
