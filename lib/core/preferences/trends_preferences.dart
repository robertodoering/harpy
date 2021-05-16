import 'package:harpy/core/core.dart';

class TrendsPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// The json encoded string for the trends location.
  String get trendsLocation => harpyPrefs.getString('trendsLocation', '')!;
  set trendsLocation(String value) =>
      harpyPrefs.setString('trendsLocation', value);
}
