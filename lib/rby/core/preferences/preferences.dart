import 'package:encrypt/encrypt.dart';
import 'package:harpy/rby/core/logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [SharedPreferences] wrapper that allows for prefixed keys.
///
/// Includes a basic non-encrypted implementation and an encrypted
/// implementation.
///
/// * [_BasicPreferences]
/// * [_EncryptedPreferences]
abstract class Preferences {
  const Preferences();

  const factory Preferences.basic({
    required SharedPreferences sharedPreferences,
    String? prefix,
  }) = _BasicPreferences;

  factory Preferences.encrypted({
    required SharedPreferences sharedPreferences,
    required String aesKey,
    String? prefix,
  }) = _EncryptedPreferences;

  SharedPreferences get _sharedPreferences;

  /// An optional prefix that will be used for all keys when provided.
  String? get _prefix;

  int getInt(String key, int defaultValue);
  double getDouble(String key, double defaultValue);
  bool getBool(String key, bool defaultValue);
  String getString(String key, String defaultValue);
  List<String> getStringList(String key, List<String> defaultValue);

  void setInt(String key, int value);
  void setDouble(String key, double value);
  void setBool(String key, bool value);
  void setString(String key, String value);
  void setStringList(String key, List<String> value);

  void remove(String key) => _sharedPreferences.remove(_buildKey(key));

  String _buildKey(String key) {
    if (_prefix?.isNotEmpty ?? false) {
      return '$_prefix.$key';
    } else {
      return key;
    }
  }
}

class _BasicPreferences extends Preferences {
  const _BasicPreferences({
    required SharedPreferences sharedPreferences,
    String? prefix,
  })  : _sharedPreferences = sharedPreferences,
        _prefix = prefix;

  @override
  final SharedPreferences _sharedPreferences;

  @override
  final String? _prefix;

  @override
  int getInt(String key, int defaultValue) =>
      _sharedPreferences.getInt(_buildKey(key)) ?? defaultValue;

  @override
  double getDouble(String key, double defaultValue) =>
      _sharedPreferences.getDouble(_buildKey(key)) ?? defaultValue;

  @override
  bool getBool(String key, bool defaultValue) =>
      _sharedPreferences.getBool(_buildKey(key)) ?? defaultValue;

  @override
  String getString(String key, String defaultValue) =>
      _sharedPreferences.getString(_buildKey(key)) ?? defaultValue;

  @override
  List<String> getStringList(String key, List<String> defaultValue) =>
      _sharedPreferences.getStringList(_buildKey(key)) ?? defaultValue;

  @override
  void setInt(String key, int value) =>
      _sharedPreferences.setInt(_buildKey(key), value);

  @override
  void setDouble(String key, double value) =>
      _sharedPreferences.setDouble(_buildKey(key), value);

  @override
  void setBool(String key, bool value) =>
      _sharedPreferences.setBool(_buildKey(key), value);

  @override
  void setString(String key, String value) =>
      _sharedPreferences.setString(_buildKey(key), value);

  @override
  void setStringList(String key, List<String> value) =>
      _sharedPreferences.setStringList(_buildKey(key), value);
}

class _EncryptedPreferences extends Preferences with LoggerMixin {
  _EncryptedPreferences({
    required SharedPreferences sharedPreferences,
    required String aesKey,
    String? prefix,
  })  : _sharedPreferences = sharedPreferences,
        _prefix = prefix,
        _encrypter = Encrypter(AES(Key.fromBase64(aesKey)));

  final Encrypter _encrypter;

  @override
  final SharedPreferences _sharedPreferences;

  @override
  final String? _prefix;

  @override
  int getInt(String key, int defaultValue) {
    final value = _getAndDecryptValue(key);

    return value != null ? int.tryParse(value) ?? defaultValue : defaultValue;
  }

  @override
  double getDouble(String key, double defaultValue) {
    final value = _getAndDecryptValue(key);

    return value != null
        ? double.tryParse(value) ?? defaultValue
        : defaultValue;
  }

  @override
  bool getBool(String key, bool defaultValue) {
    final value = _getAndDecryptValue(key);

    return value == 'true' || value == 'false' ? value == 'true' : defaultValue;
  }

  @override
  String getString(String key, String defaultValue) =>
      _getAndDecryptValue(key) ?? defaultValue;

  @override
  List<String> getStringList(String key, List<String> defaultValue) =>
      throw UnimplementedError();

  @override
  void setInt(String key, int value) => _setAndEncryptValue(key, value);

  @override
  void setDouble(String key, double value) => _setAndEncryptValue(key, value);

  @override
  void setBool(String key, bool value) => _setAndEncryptValue(key, value);

  @override
  void setString(String key, String value) => _setAndEncryptValue(key, value);

  @override
  void setStringList(String key, List<String> value) =>
      throw UnimplementedError();

  @override
  String _buildKey(String unencryptedKey) {
    // constant iv for the key
    final iv = IV.fromLength(16);

    return _encrypter.encrypt(super._buildKey(unencryptedKey), iv: iv).base64;
  }

  void _setAndEncryptValue(String unencryptedKey, dynamic unencryptedValue) {
    final iv = IV.fromSecureRandom(16);
    final encrypted = _encrypter.encrypt('$unencryptedValue', iv: iv);

    _sharedPreferences.setString(
      _buildKey(unencryptedKey),
      '${iv.base64}:${encrypted.base64}',
    );
  }

  String? _getAndDecryptValue(String unencryptedKey) {
    final value = _sharedPreferences.getString(_buildKey(unencryptedKey));

    if (value == null) {
      return null;
    } else {
      try {
        final pair = value.split(':');

        final iv = IV.fromBase64(pair[0]);
        final encrypted = Encrypted.fromBase64(pair[1]);

        return _encrypter.decrypt(encrypted, iv: iv);
      } catch (e, st) {
        log.severe(e, st);
        return null;
      }
    }
  }
}
