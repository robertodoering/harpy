import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/settings/theme/bloc/theme_event.dart';
import 'package:harpy/components/settings/theme/bloc/theme_state.dart';
import 'package:harpy/core/preferences/theme_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/harpy_theme_data.dart';
import 'package:harpy/core/theme/predefined_themes.dart';
import 'package:logging/logging.dart';

/// The [ThemeBloc] handles initialization of the [HarpyTheme] that creates the
/// [ThemeData] used by the root [MaterialApp].
///
/// When a user is authenticated, their selected theme and their custom themes
/// are loaded using the [ThemePreferences].
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(UninitializedState());

  static ThemeBloc of(BuildContext context) => context.bloc<ThemeBloc>();

  static final Logger _log = Logger('ThemeBloc');

  /// The [HarpyTheme] used in the root [MaterialApp].
  HarpyTheme harpyTheme = predefinedThemes.first;

  /// The list of custom themes for the currently authenticated user.
  ///
  /// Is empty when no user is authenticated, or when the user has no custom
  /// themes.
  /// Custom themes can only be created with Harpy Pro.
  List<HarpyTheme> customThemes = <HarpyTheme>[];

  HarpyThemeData _decodeThemeData(String themeDataJson) {
    try {
      return HarpyThemeData.fromJson(jsonDecode(themeDataJson));
    } catch (e, st) {
      _log.warning('unable to decode custom theme data', e, st);
      return null;
    }
  }

  /// Loads the custom themes from the [ThemePreferences] for the currently
  /// authenticated user.
  void loadCustomThemes() {
    customThemes = app<ThemePreferences>()
        .customThemes
        .map(_decodeThemeData)
        .where((HarpyThemeData themeData) => themeData != null)
        .map((HarpyThemeData themeData) => HarpyTheme.fromData(themeData))
        .toList();
  }

  /// Updates the system ui to match the current [harpyTheme].
  void updateSystemUi() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: harpyTheme.backgroundColors.last,
        systemNavigationBarDividerColor: null,
        systemNavigationBarIconBrightness: harpyTheme.complimentaryBrightness,
        statusBarColor: harpyTheme.backgroundColors.first,
        statusBarBrightness: harpyTheme.brightness,
        statusBarIconBrightness: harpyTheme.complimentaryBrightness,
      ),
    );
  }

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
