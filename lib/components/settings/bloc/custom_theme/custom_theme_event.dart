import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harpy/components/settings/bloc/custom_theme/custom_theme_bloc.dart';
import 'package:harpy/components/settings/bloc/custom_theme/custom_theme_state.dart';
import 'package:harpy/core/preferences/theme_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/harpy_theme_data.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CustomThemeEvent {
  const CustomThemeEvent();

  Stream<CustomThemeState> applyAsync({
    CustomThemeState currentState,
    CustomThemeBloc bloc,
  });
}

/// Loads and decodes the custom themes for the active user and stores the
/// themes in [CustomThemeBloc.customThemes].
class LoadCustomThemesEvent extends CustomThemeEvent {
  const LoadCustomThemesEvent();

  static final Logger _log = Logger('LoadCustomThemesEvent');

  HarpyThemeData _decodeThemeData(String themeData) {
    try {
      return HarpyThemeData.fromJson(jsonDecode(themeData));
    } catch (e, st) {
      _log.warning('unable to decode custom theme data', e, st);
      return null;
    }
  }

  @override
  Stream<CustomThemeState> applyAsync({
    CustomThemeState currentState,
    CustomThemeBloc bloc,
  }) async* {
    bloc.customThemes = app<ThemePreferences>()
        .customThemes
        .map(_decodeThemeData)
        .where((HarpyThemeData themeData) => themeData != null)
        .map((HarpyThemeData themeData) => HarpyTheme.fromData(themeData))
        .toList();

    yield InitializedState();
    bloc.loadCustomThemesCompleter.complete();
    bloc.loadCustomThemesCompleter = Completer<void>();
  }
}

/// Clears the cached custom themes and resets the state.
///
/// Called when a user logs out to reset the [CustomThemeBloc].
class ClearCustomThemesEvent extends CustomThemeEvent {
  const ClearCustomThemesEvent();

  @override
  Stream<CustomThemeState> applyAsync({
    CustomThemeState currentState,
    CustomThemeBloc bloc,
  }) async* {
    bloc.customThemes = <HarpyTheme>[];
    yield UninitializedState();
  }
}
