import 'package:harpy/core/config/app_configuration.dart';
import 'package:harpy/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HarpyPrefs {
  SharedPreferences preferences;

  static HarpyPrefs _instance = HarpyPrefs._();
  factory HarpyPrefs() => _instance;
  HarpyPrefs._();

  /// The [_prefix] is used in keys for user specific preferences.
  String get _prefix => AppConfiguration().twitterSession?.userId;

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  String get themeName =>
      preferences.getString("$_prefix.themeName") ?? HarpyTheme.dark().name;

  set themeName(String themeName) =>
      preferences.setString("$_prefix.themeName", themeName);
}
