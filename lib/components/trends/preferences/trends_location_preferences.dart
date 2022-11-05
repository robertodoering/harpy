import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

part 'trends_location_preferences.freezed.dart';

final trendsLocationPreferencesProvider = StateNotifierProvider<
    TrendsLocationPreferencesNotifier, TrendsLocationPreferences>(
  (ref) => TrendsLocationPreferencesNotifier(
    preferences: ref.watch(preferencesProvider(null)),
  ),
  name: 'TrendsLocationPreferences',
);

class TrendsLocationPreferencesNotifier
    extends StateNotifier<TrendsLocationPreferences> {
  TrendsLocationPreferencesNotifier({
    required Preferences preferences,
  })  : _preferences = preferences,
        super(
          TrendsLocationPreferences(
            trendsLocationData: preferences.getString('trendsLocation', ''),
          ),
        );

  final Preferences _preferences;

  void setTrendsLocationData(String value) {
    state = state.copyWith(trendsLocationData: value);
    _preferences.setString('trendsLocation', value);
  }
}

@freezed
class TrendsLocationPreferences with _$TrendsLocationPreferences {
  const factory TrendsLocationPreferences({
    /// The json encoded string for the trends location.
    required String trendsLocationData,
  }) = _TrendsLocationPreferences;
}
