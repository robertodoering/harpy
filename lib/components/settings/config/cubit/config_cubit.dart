import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

part 'config.dart';

/// Handles loading, updating and persisting the [Config] which is used for
/// configuration of ui components in the app.
class ConfigCubit extends Cubit<Config> {
  ConfigCubit() : super(Config.defaultConfig);

  void initialize() {
    final fontSizeDeltaId = app<HarpyPreferences>().getInt(
      'fontSizeDeltaId',
      0,
    );

    final compactMode = app<HarpyPreferences>().getBool('compactMode', false);
    final bottomAppBar = app<HarpyPreferences>().getBool('bottomAppBar', false);
    final hideHomeTabBar = app<HarpyPreferences>().getBool(
      'hideHomeTabBar',
      true,
    );

    final displayFontFamily = app<HarpyPreferences>().getString(
      'displayFontFamily',
      kDisplayFontFamily,
    );

    final bodyFontFamily = app<HarpyPreferences>().getString(
      'bodyFontFamily',
      kBodyFontFamily,
    );

    final showAbsoluteTime = app<HarpyPreferences>().getBool(
      'showAbsoluteTime',
      false,
    );

    emit(
      state.copyWith(
        compactMode: compactMode,
        fontSizeDelta: _fontSizeDeltaIdMap[fontSizeDeltaId] ?? 0,
        bottomAppBar: bottomAppBar,
        displayFont: displayFontFamily,
        bodyFont: bodyFontFamily,
        hideHomeTabBar: hideHomeTabBar,
        showAbsoluteTime: showAbsoluteTime,
      ),
    );
  }

  void resetToDefault() {
    app<HarpyPreferences>().setInt('fontSizeDeltaId', 0);
    app<HarpyPreferences>().setBool('compactMode', false);
    app<HarpyPreferences>().setBool('bottomAppBar', false);

    app<HarpyPreferences>().setString(
      'displayFontFamily',
      kDisplayFontFamily,
    );

    app<HarpyPreferences>().setString(
      'bodyFontFamily',
      kBodyFontFamily,
    );

    app<HarpyPreferences>().setBool(
      'showAbsoluteTime',
      false,
    );

    emit(Config.defaultConfig);
  }

  void updateCompactMode(bool value) {
    app<HarpyPreferences>().setBool('compactMode', value);

    emit(state.copyWith(compactMode: value));
  }

  void updateFontSizeDelta(double value) {
    final fontSizeDeltaId = _fontSizeDeltaIdMap.entries
        .firstWhere(
          (element) => element.value == value,
          orElse: () => const MapEntry<int, double>(0, 0),
        )
        .key;

    app<HarpyPreferences>().setInt('fontSizeDeltaId', fontSizeDeltaId);

    emit(
      state.copyWith(
        fontSizeDelta: _fontSizeDeltaIdMap[fontSizeDeltaId] ?? 0,
      ),
    );
  }

  void updateDisplayFont(String fontFamily) {
    app<HarpyPreferences>().setString('displayFontFamily', fontFamily);

    emit(state.copyWith(displayFont: fontFamily));
  }

  void updateBodyFont(String fontFamily) {
    app<HarpyPreferences>().setString('bodyFontFamily', fontFamily);

    emit(state.copyWith(bodyFont: fontFamily));
  }

  void updateBottomAppBar(bool value) {
    app<HarpyPreferences>().setBool('bottomAppBar', value);

    emit(state.copyWith(bottomAppBar: value));
  }

  void updateHideHomeTabBar(bool value) {
    app<HarpyPreferences>().setBool('hideHomeTabBar', value);

    emit(state.copyWith(hideHomeTabBar: value));
  }

  void updateShowAbsoluteTime(bool value) {
    app<HarpyPreferences>().setBool('showAbsoluteTime', value);

    emit(state.copyWith(showAbsoluteTime: value));
  }
}
