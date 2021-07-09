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

    yield state.copyWith(
      lightThemeData: _themeDataFromId(lightThemeId, state),
      darkThemeData: _themeDataFromId(darkThemeId, state),
    );
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
    }
  }
}

void _persistCustomThemes(List<HarpyThemeData> customThemesData) {
  final log = Logger('$_persistCustomThemes');

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
