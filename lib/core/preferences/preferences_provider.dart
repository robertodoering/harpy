import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(),
  name: 'SharedPreferencesProvider',
);

final preferencesProvider = Provider.family<Preferences, String?>(
  (ref, prefix) => Preferences.basic(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
    prefix: prefix,
  ),
  name: 'PreferencesProvider',
);

final encryptedPreferencesProvider = Provider.family<Preferences, String?>(
  (ref, prefix) => Preferences.encrypted(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
    aesKey: ref.watch(environmentProvider).aesKey,
    prefix: prefix,
  ),
  name: 'EncryptedPreferencesProvider',
);
