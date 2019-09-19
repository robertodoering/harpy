import 'package:harpy/models/application_model.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wraps the [SharedPreferences].
///
/// A [prefix] is used to differentiate between different users for user
/// specific settings.
class HarpyPrefs {
  static final Logger _log = Logger("HarpyPrefs");

  ApplicationModel applicationModel;

  SharedPreferences preferences;

  /// The [prefix] is used in keys for user specific preferences.
  String get prefix => applicationModel.twitterSession.userId;

  Future<void> init() async {
    _log.fine("initializing harpy prefs");
    preferences = await SharedPreferences.getInstance();
  }

  /// Gets the int value for the [key] if it exists.
  ///
  /// Limits the value if [lowerLimit] and [upperLimit] are not `null`.
  int getInt(String key, int defaultValue, [int lowerLimit, int upperLimit]) {
    try {
      final int value = preferences.getInt(key) ?? defaultValue;

      if (lowerLimit != null && upperLimit != null) {
        return value.clamp(lowerLimit, upperLimit);
      }

      return value;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Gets the string list for the [key] or an empty list if it doesn't exist.
  List<String> getStringList(String key) {
    try {
      return preferences.getStringList(key) ?? <String>[];
    } catch (e) {
      return <String>[];
    }
  }
}
