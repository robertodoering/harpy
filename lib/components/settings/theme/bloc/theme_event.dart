import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harpy/components/settings/theme/bloc/theme_bloc.dart';
import 'package:harpy/components/settings/theme/bloc/theme_state.dart';
import 'package:harpy/core/analytics_service.dart';
import 'package:harpy/core/preferences/theme_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/predefined_themes.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ThemeEvent {
  const ThemeEvent();

  Stream<ThemeState> applyAsync({
    ThemeState currentState,
    ThemeBloc bloc,
  });
}

/// The event to change the app wide theme.
class ChangeThemeEvent extends ThemeEvent {
  const ChangeThemeEvent({
    @required this.id,
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

  HarpyTheme _findTheme(ThemeBloc bloc) {
    try {
      if (id < 10) {
        return predefinedThemes[id];
      } else {
        // selected theme id = 10 -> index = 0
        final int index = id - 10;
        return bloc.customThemes[index];
      }
    } catch (e, st) {
      _log.severe('theme id does not correspond to a theme', e, st);
      return null;
    }
  }

  @override
  Stream<ThemeState> applyAsync({
    ThemeState currentState,
    ThemeBloc bloc,
  }) async* {
    final HarpyTheme harpyTheme = _findTheme(bloc);

    if (harpyTheme != null) {
      _log.fine('changing theme to ${harpyTheme.name}');
      bloc.harpyTheme = harpyTheme;

      if (saveSelection) {
        app<ThemePreferences>().selectedTheme = id;
        app<AnalyticsService>().logThemeId(id);
      }
    }

    bloc.updateSystemUi();

    yield ThemeSetState();
  }
}
