import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/core/core.dart';

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

    final displayFontFamily = app<HarpyPreferences>().getString(
      'displayFontFamily',
      'Comfortaa',
    );

    final bodyFontFamily = app<HarpyPreferences>().getString(
      'bodyFontFamily',
      'OpenSans',
    );

    emit(
      state.copyWith(
        compactMode: compactMode,
        fontSizeDelta: _fontSizeDeltaIdMap[fontSizeDeltaId] ?? 0,
        bottomAppBar: bottomAppBar,
        displayFont: displayFontFamily != null
            ? CustomFont(fontFamily: displayFontFamily)
            : null,
        bodyFont: bodyFontFamily != null
            ? CustomFont(fontFamily: bodyFontFamily)
            : null,
      ),
    );
  }

  void resetToDefault() {
    app<HarpyPreferences>().setInt('fontSizeDeltaId', 0);
    app<HarpyPreferences>().setBool('compactMode', false);
    app<HarpyPreferences>().setBool('bottomAppBar', false);

    app<HarpyPreferences>().setString('displayFontFamily', 'Comfortaa');
    app<HarpyPreferences>().setString('bodyFontFamily', 'OpenSans');

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

    emit(
      state.copyWith(
        displayFont: CustomFont(
          fontFamily: fontFamily,
        ),
      ),
    );
  }

  void updateBodyFont(String fontFamily) {
    app<HarpyPreferences>().setString('bodyFontFamily', fontFamily);

    emit(
      state.copyWith(
        bodyFont: CustomFont(
          fontFamily: fontFamily,
        ),
      ),
    );
  }

  void updateBottomAppBar(bool value) {
    app<HarpyPreferences>().setBool('bottomAppBar', value);

    emit(state.copyWith(bottomAppBar: value));
  }
}
