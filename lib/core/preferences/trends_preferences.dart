import 'package:harpy/core/core.dart';

class TrendsPreferences {
  const TrendsPreferences();

  /// The json encoded string for the trends location.
  String get trendsLocation =>
      app<HarpyPreferences>().getString('trendsLocation', '');
  set trendsLocation(String value) =>
      app<HarpyPreferences>().setString('trendsLocation', value);
}
