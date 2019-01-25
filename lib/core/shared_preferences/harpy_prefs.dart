import 'package:harpy/core/config/app_configuration.dart';
import 'package:harpy/theme.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HarpyPrefs {
  final Logger _log = Logger("HarpyPrefs");

  SharedPreferences _preferences;

  static HarpyPrefs _instance = HarpyPrefs._();
  factory HarpyPrefs() => _instance;
  HarpyPrefs._();

  /// The [_prefix] is used in keys for user specific preferences.
  String get _prefix => AppConfiguration().twitterSession?.userId;

  Future<void> init() async {
    _log.fine("initializing harpy prefs");
    _preferences = await SharedPreferences.getInstance();
  }

  String get themeName =>
      _preferences.getString("$_prefix.themeName") ?? HarpyTheme.dark().name;

  set themeName(String themeName) =>
      _preferences.setString("$_prefix.themeName", themeName);
}
