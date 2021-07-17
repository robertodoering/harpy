part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {
  const ThemeEvent();

  Stream<ThemeState> applyAsync({
    required ThemeState state,
    required ThemeBloc bloc,
  });
}

class UpdateThemeConfig extends ThemeEvent with HarpyLogger {
  const UpdateThemeConfig({
    required this.config,
  });

  final ConfigState config;

  @override
  Stream<ThemeState> applyAsync({
    required ThemeState state,
    required ThemeBloc bloc,
  }) async* {
    log.fine('updated theme config');

    yield state.copyWith(config: config);
  }
}

class ChangeTheme extends ThemeEvent with HarpyLogger {
  const ChangeTheme({
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
  Stream<ThemeState> applyAsync({
    required ThemeState state,
    required ThemeBloc bloc,
  }) async* {
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

    final lightThemeData = _themeDataFromId(lightThemeId, state);
    final darkThemeData = _themeDataFromId(darkThemeId, state);

    if (lightThemeData != null || darkThemeData != null) {
      final newState = state.copyWith(
        lightThemeData: lightThemeData,
        darkThemeData: darkThemeData,
      );

      yield newState;
    } else {
      log.warning('no matching theme found');
    }
  }
}

class LoadCustomThemes extends ThemeEvent with HarpyLogger {
  const LoadCustomThemes();

  HarpyThemeData? _decodeThemeData(String themeDataJson) {
    try {
      return HarpyThemeData.fromJson(jsonDecode(themeDataJson));
    } catch (e, st) {
      log.warning('unable to decode custom theme data', e, st);
      return null;
    }
  }

  @override
  Stream<ThemeState> applyAsync({
    required ThemeState state,
    required ThemeBloc bloc,
  }) async* {
    log.fine('loading custom themes');

    final customThemesData = app<ThemePreferences>()
        .customThemes
        .map(_decodeThemeData)
        .whereType<HarpyThemeData>()
        .toList();

    log.fine('loaded ${customThemesData.length} custom themes');

    yield state.copyWith(customThemesData: customThemesData);
  }
}

class DeleteCustomTheme extends ThemeEvent with HarpyLogger {
  const DeleteCustomTheme({
    required this.themeId,
  });

  final int themeId;

  @override
  Stream<ThemeState> applyAsync({
    required ThemeState state,
    required ThemeBloc bloc,
  }) async* {
    log.fine('deleting custom theme $themeId');

    final index = themeId - 10;

    final customThemesData = List.of(state.customThemesData);

    if (index >= 0 && index < customThemesData.length) {
      customThemesData.removeAt(index);

      _persistCustomThemes(customThemesData);
      yield state.copyWith(customThemesData: customThemesData);

      final lightThemeId = app<ThemePreferences>().lightThemeId;
      final darkThemeId = app<ThemePreferences>().darkThemeId;

      // reset selection when deleting a selected theme
      if (themeId == lightThemeId || themeId == darkThemeId) {
        bloc.add(ChangeTheme(
          lightThemeId: themeId == lightThemeId ? 0 : null,
          darkThemeId: themeId == darkThemeId ? 0 : null,
          saveSelection: true,
        ));
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
class AddCustomTheme extends ThemeEvent with HarpyLogger {
  const AddCustomTheme({
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
  Stream<ThemeState> applyAsync({
    required ThemeState state,
    required ThemeBloc bloc,
  }) async* {
    log.fine('adding custom theme at $themeId');

    final index = themeId - 10;

    final customThemesData = List.of(state.customThemesData);

    // add or modify theme
    if (index >= 0 && index < customThemesData.length) {
      customThemesData[index] = themeData;

      _persistCustomThemes(customThemesData);
      yield state.copyWith(customThemesData: customThemesData);
    } else if (index >= customThemesData.length) {
      customThemesData.add(themeData);

      _persistCustomThemes(customThemesData);
      yield state.copyWith(customThemesData: customThemesData);
    } else {
      log.warning('unexpected custom themes state');
    }

    // change selection to new theme
    if (changeLightThemeSelection || changeDarkThemeSelection) {
      bloc.add(ChangeTheme(
        lightThemeId: changeLightThemeSelection ? themeId : null,
        darkThemeId: changeDarkThemeSelection ? themeId : null,
        saveSelection: true,
      ));
    }
  }
}

void _persistCustomThemes(List<HarpyThemeData> customThemesData) {
  final log = Logger('_persistCustomThemes');

  log.fine('saving custom themes');

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
