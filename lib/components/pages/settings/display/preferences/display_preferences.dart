import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

part 'display_preferences.freezed.dart';

final displayPreferencesProvider =
    StateNotifierProvider<DisplayPreferencesNotifier, DisplayPreferences>(
  (ref) => DisplayPreferencesNotifier(
    preferences: ref.watch(preferencesProvider(null)),
  ),
  name: 'DisplayPreferencesProvider',
);

class DisplayPreferencesNotifier extends StateNotifier<DisplayPreferences> {
  DisplayPreferencesNotifier({
    required Preferences preferences,
  })  : _preferences = preferences,
        super(
          DisplayPreferences(
            compactMode: preferences.getBool('compactMode', false),
            displayFont: preferences.getString(
              'displayFontFamily',
              kDisplayFont,
            ),
            bodyFont: preferences.getString(
              'bodyFontFamily',
              kBodyFont,
            ),
            fontSizeDeltaId: preferences.getInt('fontSizeDeltaId', 0),
            absoluteTweetTime: preferences.getBool('showAbsoluteTime', false),
          ),
        );

  final Preferences _preferences;

  void setCompactMode(bool value) {
    state = state.copyWith(compactMode: value);
    _preferences.setBool('compactMode', value);
  }

  void setDisplayFont(String value) {
    state = state.copyWith(displayFont: value);
    _preferences.setString('displayFontFamily', value);
  }

  void setBodyFont(String value) {
    state = state.copyWith(bodyFont: value);
    _preferences.setString('bodyFontFamily', value);
  }

  void setFontSizeDeltaId(int value) {
    state = state.copyWith(fontSizeDeltaId: value);
    _preferences.setInt('fontSizeDeltaId', value);
  }

  void setAbsoluteTweetTime(bool value) {
    state = state.copyWith(absoluteTweetTime: value);
    _preferences.setBool('showAbsoluteTime', value);
  }
}

@freezed
class DisplayPreferences with _$DisplayPreferences {
  factory DisplayPreferences({
    required bool compactMode,
    required String displayFont,
    required String bodyFont,
    required int fontSizeDeltaId,
    required bool absoluteTweetTime,
  }) = _DisplayPreferences;

  DisplayPreferences._();

  late final double fontSizeDelta = _fontSizeDeltaIdMap[fontSizeDeltaId] ?? 0;
}

extension DisplayPreferencesExtension on DisplayPreferences {
  double get paddingValue => compactMode ? 12 : 16;
  double get smallPaddingValue => paddingValue / 2;

  EdgeInsets get edgeInsets => EdgeInsets.all(paddingValue);

  EdgeInsets edgeInsetsOnly({
    bool left = false,
    bool right = false,
    bool top = false,
    bool bottom = false,
  }) {
    return EdgeInsets.only(
      left: left ? paddingValue : 0,
      right: right ? paddingValue : 0,
      top: top ? paddingValue : 0,
      bottom: bottom ? paddingValue : 0,
    );
  }

  EdgeInsets edgeInsetsSymmetric({
    bool horizontal = false,
    bool vertical = false,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal ? paddingValue : 0,
      vertical: vertical ? paddingValue : 0,
    );
  }
}

/// Maps the id of the font size to the font size delta value.
const _fontSizeDeltaIdMap = <int, double>{
  -2: -4,
  -1: -2,
  0: 0,
  1: 2,
  2: 4,
};