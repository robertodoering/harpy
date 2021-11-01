import 'package:harpy/core/core.dart';

class SetupPreferences {
  const SetupPreferences();

  /// Whether the currently authenticated user has been through the setup after
  /// their first login.
  bool get performedSetup =>
      app<HarpyPreferences>().getBool('performedSetup2', false, prefix: true);
  set performedSetup(bool value) =>
      app<HarpyPreferences>().setBool('performedSetup2', value, prefix: true);
}
