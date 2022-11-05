import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

part 'layout_preferences.freezed.dart';

final layoutPreferencesProvider =
    StateNotifierProvider<LayoutPreferencesNotifier, LayoutPreferences>(
  (ref) => LayoutPreferencesNotifier(
    preferences: ref.watch(preferencesProvider(null)),
  ),
  name: 'LayoutPreferencesProvider',
);

class LayoutPreferencesNotifier extends StateNotifier<LayoutPreferences> {
  LayoutPreferencesNotifier({
    required Preferences preferences,
  })  : _preferences = preferences,
        super(
          LayoutPreferences(
            mediaTiled: preferences.getBool('mediaTiled', true),
          ),
        );

  final Preferences _preferences;

  void setMediaTiled(bool value) {
    state = state.copyWith(mediaTiled: value);
    _preferences.setBool('mediaTiled', value);
  }
}

@freezed
class LayoutPreferences with _$LayoutPreferences {
  const factory LayoutPreferences({
    /// Whether the media in a media timeline should be tiled.
    required bool mediaTiled,
  }) = _LayoutPreferences;
}
