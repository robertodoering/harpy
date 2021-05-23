part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {
  const ThemeEvent();

  Stream<ThemeState> applyAsync({
    required ThemeState currentState,
    required ThemeBloc bloc,
  });
}

/// The event to change the app wide theme.
class ChangeThemeEvent extends ThemeEvent {
  const ChangeThemeEvent({
    required this.id,
    this.saveSelection = false,
  });

  /// The `id` used to save the selection to.
  ///
  /// 0..9: index of predefined theme (unused indices are reserved)
  /// 10+: index of custom theme (pro only)
  final int id;

  /// Whether the selection should be saved using the [ThemePreferences].
  final bool saveSelection;

  static final Logger _log = Logger('ChangeThemeEvent');

  HarpyTheme? _findTheme(ThemeBloc bloc) {
    try {
      if (id < 10) {
        return id > 0 ? predefinedThemes[id] : predefinedThemes[0];
      } else {
        // selected theme id = 10 -> index = 0
        final index = id - 10;

        _log.fine('using custom theme with index $index');

        return bloc.customThemes[index];
      }
    } catch (e, st) {
      _log.severe('theme id does not correspond to a theme', e, st);
      return null;
    }
  }

  @override
  Stream<ThemeState> applyAsync({
    required ThemeState currentState,
    required ThemeBloc bloc,
  }) async* {
    final harpyTheme = _findTheme(bloc);

    if (harpyTheme != null) {
      _log.fine('changing theme to ${harpyTheme.name} with id $id');
      bloc.harpyTheme = harpyTheme;

      if (saveSelection) {
        app<ThemePreferences>().selectedTheme = id;
        app<AnalyticsService>().logThemeId(id);
      }
    }

    bloc.updateSystemUi(bloc.harpyTheme);

    yield ThemeSetState();
  }
}

/// Updates the system ui based on the [theme].
///
/// Does not yield anything.
class UpdateSystemUi extends ThemeEvent {
  const UpdateSystemUi({
    required this.theme,
  });

  final HarpyTheme theme;

  @override
  Stream<ThemeState> applyAsync({
    required ThemeState currentState,
    required ThemeBloc bloc,
  }) async* {
    bloc.updateSystemUi(theme);
  }
}

/// Saves the custom themes in [ThemeBloc.customThemes] using the
/// [ThemePreferences].
class SaveCustomThemes extends ThemeEvent {
  const SaveCustomThemes();

  static final Logger _log = Logger('SaveCustomThemes');

  String? _encodeThemeData(HarpyThemeData themeData) {
    try {
      return jsonEncode(themeData.toJson());
    } catch (e, st) {
      _log.warning('unable to encode custom theme data', e, st);
      return null;
    }
  }

  @override
  Stream<ThemeState> applyAsync({
    required ThemeState currentState,
    required ThemeBloc bloc,
  }) async* {
    final encodedCustomThemes = bloc.customThemes
        .map((theme) => HarpyThemeData.fromHarpyTheme(theme))
        .map(_encodeThemeData)
        .where((themeDataJson) => themeDataJson != null)
        .toList();

    _log.fine('saving ${encodedCustomThemes.length} custom themes');

    app<ThemePreferences>().customThemes = encodedCustomThemes;
  }
}

class RefreshTheme extends ThemeEvent {
  const RefreshTheme();

  @override
  Stream<ThemeState> applyAsync({
    required ThemeState currentState,
    required ThemeBloc bloc,
  }) async* {
    bloc.add(ChangeThemeEvent(id: app<ThemePreferences>().selectedTheme));
  }
}
