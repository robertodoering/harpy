import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wraps the [SharedPreferences].
class HarpyPreferences {
  static final Logger _log = Logger('HarpyPreferences');

  SharedPreferences _preferences;

  /// Can be used to prefix the given key.
  ///
  /// Used to differentiate user preferences.
  String prefix;

  /// Initializes the [_preferences] instance.
  Future<void> initialize() async {
    _log.fine('initializing harpy preferences');
    _preferences = await SharedPreferences.getInstance();
  }

  String _key(String key, bool usePrefix) {
    if (usePrefix && prefix.isNotEmpty == true) {
      return '$prefix.$key';
    } else {
      return key;
    }
  }

  /// Gets the int value for the [key] if it exists.
  ///
  /// Limits the value if [lowerLimit] and [upperLimit] are not `null`.
  int getInt(
    String key,
    int defaultValue, {
    bool prefix = false,
    int lowerLimit,
    int upperLimit,
  }) {
    try {
      final int value = _preferences.getInt(_key(key, prefix)) ?? defaultValue;

      if (lowerLimit != null && upperLimit != null) {
        return value.clamp(lowerLimit, upperLimit);
      }

      return value;
    } catch (e) {
      return defaultValue;
    }
  }

  void setInt(
    String key,
    int value, {
    bool prefix = false,
  }) {
    _log.fine('set ${_key(key, prefix)} to $value');
    _preferences.setInt(_key(key, prefix), value);
  }

  /// Gets the bool value for the [key] if it exists.
  bool getBool(
    String key,
    bool defaultValue, {
    bool prefix = false,
  }) {
    try {
      return _preferences.getBool(_key(key, prefix)) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  void setBool(
    String key,
    bool value, {
    bool prefix = false,
  }) {
    _log.fine('set ${_key(key, prefix)} to $value');
    _preferences.setBool(_key(key, prefix), value);
  }

  String getString(
    String key,
    String defaultValue, {
    bool prefix = false,
  }) {
    try {
      return _preferences.getString(_key(key, prefix)) ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  void setString(
    String key,
    String value, {
    bool prefix = false,
  }) {
    _log.fine('set ${_key(key, prefix)} to $value');
    _preferences.setString(_key(key, prefix), value);
  }

  /// Gets the string list for the [key] or an empty list if it doesn't exist.
  List<String> getStringList(
    String key, {
    bool prefix = false,
  }) {
    try {
      return _preferences.getStringList(_key(key, prefix)) ?? <String>[];
    } catch (e) {
      return <String>[];
    }
  }

  void setStringList(
    String key,
    List<String> value, {
    bool prefix = false,
  }) {
    _log.fine('set ${_key(key, prefix)} to $value');
    _preferences.setStringList(_key(key, prefix), value);
  }

  void remove(
    String key, {
    bool prefix = false,
  }) {
    _log.fine('remove ${_key(key, prefix)}');
    _preferences.remove(_key(key, prefix));
  }
}
