part of 'theme_bloc.dart';

abstract class ThemeEvent {
  const ThemeEvent();

  const factory ThemeEvent.updateConfig({
    required Config config,
  }) = _UpdateConfig;

  const factory ThemeEvent.changeTheme({
    required int? lightThemeId,
    required int? darkThemeId,
    bool saveSelection,
  }) = _ChangeTheme;

  const factory ThemeEvent.loadCustomThemes() = _LoadCustomThemes;

  const factory ThemeEvent.deleteCustomTheme({
    required int themeId,
  }) = _DeleteCustomTheme;

  const factory ThemeEvent.addCustomTheme({
    required HarpyThemeData themeData,
    required int themeId,
    bool changeLightThemeSelection,
    bool changeDarkThemeSelection,
  }) = _AddCustomTheme;

  Future<void> handle(ThemeBloc bloc, Emitter emit);
}

class _UpdateConfig extends ThemeEvent with HarpyLogger {
  const _UpdateConfig({
    required this.config,
  });

  final Config config;

  @override
  Future<void> handle(ThemeBloc bloc, Emitter emit) async {
    log.fine('updated theme config');

    emit(bloc.state.copyWith(config: config));
  }
}

class _ChangeTheme extends ThemeEvent with HarpyLogger {
  const _ChangeTheme({
    this.lightThemeId,
    this.darkThemeId,
    this.saveSelection = false,
  }) : assert(lightThemeId != null || darkThemeId != null);

  /// The id of the light and / or dark theme to select.
  ///
  /// 0..9: index of predefined theme (unused indices are reserved)
  /// 10+: index of custom theme
  final int? lightThemeId;
  final int? darkThemeId;

  final bool saveSelection;

  HarpyThemeData? _themeDataFromId(int? id, ThemeState state) {
    if (id == null) {
      return null;
    }

    if (id >= 0 && id < predefinedThemes.length) {
      return predefinedThemes[id];
    } else if (id >= 10) {
      if (id - 10 < state.customThemesData.length) {
        return state.customThemesData[id - 10];
      }
    }

    return null;
  }

  @override
  Future<void> handle(ThemeBloc bloc, Emitter emit) async {
    if (lightThemeId != null) {
      log.fine('updating light theme to id $lightThemeId');

      if (saveSelection) {
        app<ThemePreferences>().lightThemeId = lightThemeId!;
      }
    }

    if (darkThemeId != null) {
      log.fine('updating dark theme to id $darkThemeId');

      if (saveSelection) {
        app<ThemePreferences>().darkThemeId = darkThemeId!;
      }
    }

    final lightThemeData = _themeDataFromId(lightThemeId, bloc.state);
    final darkThemeData = _themeDataFromId(darkThemeId, bloc.state);

    if (lightThemeData != null || darkThemeData != null) {
      emit(
        bloc.state.copyWith(
          lightThemeData: lightThemeData ?? bloc.state.lightThemeData,
          darkThemeData: darkThemeData ?? bloc.state.darkThemeData,
        ),
      );
    } else {
      log.warning('no matching theme found');
    }
  }
}

class _LoadCustomThemes extends ThemeEvent with HarpyLogger {
  const _LoadCustomThemes();

  HarpyThemeData? _decodeThemeData(String themeDataJson) {
    try {
      return HarpyThemeData.fromJson(jsonDecode(themeDataJson));
    } catch (e, st) {
      log.warning('unable to decode custom theme data', e, st);
      return null;
    }
  }

  @override
  Future<void> handle(ThemeBloc bloc, Emitter emit) async {
    log.fine('loading custom themes');

    final customThemesData = app<ThemePreferences>()
        .customThemes
        .map(_decodeThemeData)
        .whereType<HarpyThemeData>()
        .toList();

    log.fine('loaded ${customThemesData.length} custom themes');

    emit(bloc.state.copyWith(customThemesData: customThemesData));
  }
}

class _DeleteCustomTheme extends ThemeEvent with HarpyLogger {
  const _DeleteCustomTheme({
    required this.themeId,
  });

  final int themeId;

  /// Returns the new `themeId` of the currently selected theme.
  int? _adjustedThemeId(int currentThemeId) {
    if (themeId == currentThemeId) {
      return 0;
    }
    if (themeId <= currentThemeId) {
      return currentThemeId - 1;
    }
    return null;
  }

  @override
  Future<void> handle(ThemeBloc bloc, Emitter emit) async {
    log.fine('deleting custom theme $themeId');

    final index = themeId - 10;

    final customThemesData = List.of(bloc.state.customThemesData);

    if (index >= 0 && index < customThemesData.length) {
      customThemesData.removeAt(index);

      _persistCustomThemes(customThemesData);
      emit(bloc.state.copyWith(customThemesData: customThemesData));

      final lightThemeId = app<ThemePreferences>().lightThemeId;
      final darkThemeId = app<ThemePreferences>().darkThemeId;

      if (themeId <= lightThemeId || themeId <= darkThemeId) {
        bloc.add(
          ThemeEvent.changeTheme(
            lightThemeId: _adjustedThemeId(lightThemeId),
            darkThemeId: _adjustedThemeId(darkThemeId),
            saveSelection: true,
          ),
        );
      }
    }
  }
}

/// Adds a custom theme at [themeId].
///
/// If [themeId] points to an existing custom theme, it will be modified
/// instead.
///
/// The light or dark theme selection will automatically be updated.
class _AddCustomTheme extends ThemeEvent with HarpyLogger {
  const _AddCustomTheme({
    required this.themeData,
    required this.themeId,
    this.changeLightThemeSelection = false,
    this.changeDarkThemeSelection = false,
  });

  final HarpyThemeData themeData;
  final int themeId;
  final bool changeLightThemeSelection;
  final bool changeDarkThemeSelection;

  @override
  Future<void> handle(ThemeBloc bloc, Emitter emit) async {
    log.fine('adding custom theme at $themeId');

    final index = themeId - 10;

    final customThemesData = List.of(bloc.state.customThemesData);

    // add or modify theme
    if (index >= 0 && index < customThemesData.length) {
      customThemesData[index] = themeData;

      _persistCustomThemes(customThemesData);
      emit(bloc.state.copyWith(customThemesData: customThemesData));
    } else if (index >= customThemesData.length) {
      customThemesData.add(themeData);

      _persistCustomThemes(customThemesData);
      emit(bloc.state.copyWith(customThemesData: customThemesData));
    } else {
      log.warning('unexpected custom themes state');
    }

    // change selection to new theme
    if (changeLightThemeSelection || changeDarkThemeSelection) {
      bloc.add(
        ThemeEvent.changeTheme(
          lightThemeId: changeLightThemeSelection ? themeId : null,
          darkThemeId: changeDarkThemeSelection ? themeId : null,
          saveSelection: true,
        ),
      );
    }
  }
}

void _persistCustomThemes(List<HarpyThemeData> customThemesData) {
  final log = Logger('_persistCustomThemes')..fine('saving custom themes');

  final encodedCustomThemes = customThemesData
      .map((data) {
        try {
          return jsonEncode(data.toJson());
        } catch (e, st) {
          log.warning('unable to encode custom theme data', e, st);
          return null;
        }
      })
      .whereType<String>()
      .toList();

  app<ThemePreferences>().customThemes = encodedCustomThemes;
}
