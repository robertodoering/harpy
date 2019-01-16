import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:harpy/core/filesystem/directory_service.dart';
import 'package:harpy/core/initialization/async_initializer.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:yaml/yaml.dart';

class ApplicationModel extends Model {
  ApplicationModel({
    @required this.directoryService,
  }) {
    _initialize();
  }

  final DirectoryService directoryService;

  static ApplicationModel of(BuildContext context) {
    return ScopedModel.of<ApplicationModel>(context);
  }

  /// Whether or not the [ApplicationModel] has been initialized.
  bool initialized = false;

  /// The [_twitterSession] contains information about the logged in user.
  ///
  /// If the user is not logged in [_twitterSession] will be null.
  TwitterSession _twitterSession;

  /// The [twitterLogin] is used to log in and out with the native twitter sdk.
  TwitterLogin twitterLogin;

  /// Returns true when the user has logged in with the native twitter sdk.
  ///
  /// Always false if [initialized] is also false.
  bool get loggedIn => _twitterSession != null;

  Future<void> _initialize() async {
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

    await Future.delayed(Duration(seconds: 2));

    initialized = true;
    notifyListeners();
  }

  Future<void> _initTwitterSession() async {
    String appConfig = await rootBundle.loadString(
      'app_config.yaml',
      cache: false,
    );

    // parse app config
    YamlMap yamlMap = loadYaml(appConfig);
    String consumerKey = yamlMap['twitter']['consumerKey'];
    String consumerSecret = yamlMap['twitter']['consumerSecret'];

    // init twitter login
    twitterLogin = TwitterLogin(
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
    );

    // init active twitter session
    _twitterSession = await twitterLogin.currentSession;
  }
}
