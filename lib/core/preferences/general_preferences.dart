import 'package:harpy/core/core.dart';

class GeneralPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// Whether animations and effects should be reduced to increase
  /// performance on lower end devices.
  bool get performanceMode => harpyPrefs.getBool('performanceMode', false);
  set performanceMode(bool value) =>
      harpyPrefs.setBool('performanceMode', value);

  /// Whether the user has consented to send automatic crash reports.
  bool get crashReports => harpyPrefs.getBool('crashReports', true);
  set crashReports(bool value) => harpyPrefs.setBool('crashReports', value);
}
