import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wraps the [SharedPreferences].
class HarpyPrefs {
  static final Logger _log = Logger('HarpyPrefs');

  SharedPreferences _preferences;

  /// Initializes the [_preferences] instance.
  Future<void> initialize() async {
    _log.fine('initializing harpy prefs');
    _preferences = await SharedPreferences.getInstance();
  }

  /// Gets the int value for the [key] if it exists.
  ///
  /// Limits the value if [lowerLimit] and [upperLimit] are not `null`.
  int getInt(String key, int defaultValue, [int lowerLimit, int upperLimit]) {
    try {
      final int value = _preferences.getInt(key) ?? defaultValue;

      if (lowerLimit != null && upperLimit != null) {
        return value.clamp(lowerLimit, upperLimit);
      }

      return value;
    } catch (e) {
      return defaultValue;
    }
  }

  void setInt(String key, int value) => _preferences.setInt(key, value);

  /// Gets the bool value for the [key] if it exists.
  bool getBool(String key, bool defaultValue) {
    try {
      return _preferences.getBool(key) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  void setBool(String key, bool value) => _preferences.setBool(key, value);

  /// Gets the string list for the [key] or an empty list if it doesn't exist.
  List<String> getStringList(String key) {
    try {
      return _preferences.getStringList(key) ?? <String>[];
    } catch (e) {
      return <String>[];
    }
  }

  void setStringList(String key, List<String> value) =>
      _preferences.setStringList(key, value);
}
