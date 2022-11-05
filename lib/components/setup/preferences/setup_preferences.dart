import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

final setupPreferencesProvider = Provider(
  (ref) => SetupPreferences(
    preferences: ref.watch(
      preferencesProvider(ref.watch(authPreferencesProvider).userId),
    ),
  ),
  name: 'SetupPreferencesProvider',
);

class SetupPreferences {
  const SetupPreferences({
    required Preferences preferences,
  }) : _preferences = preferences;

  final Preferences _preferences;

  /// Whether the currently authenticated user has been through the setup after
  /// their first login.
  bool get performedSetup => _preferences.getBool('performedSetup2', false);
  set performedSetup(bool value) =>
      _preferences.setBool('performedSetup2', value);
}
