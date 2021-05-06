import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:logging/logging.dart';

part 'theme_event.dart';
part 'theme_state.dart';

/// The [ThemeBloc] handles initialization of the [HarpyTheme] that creates the
/// [ThemeData] used by the root [MaterialApp].
///
/// When a user is authenticated, their selected theme and their custom themes
/// are loaded using the [ThemePreferences].
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(UninitializedState());

  static ThemeBloc of(BuildContext context) => context.watch<ThemeBloc>();

  static final Logger _log = Logger('ThemeBloc');

  /// The [HarpyTheme] used in the root [MaterialApp].
  HarpyTheme harpyTheme = predefinedThemes.first;

  /// The list of custom themes for the currently authenticated user.
  ///
  /// Is empty when no user is authenticated, or when the user has no custom
  /// themes.
  /// Custom themes can only be created when using Harpy Pro.
  List<HarpyTheme> customThemes = <HarpyTheme>[];

  /// Returns the selected theme id based off of the [ThemePreferences].
  ///
  /// If the selected theme id is `-1` (no theme selected), `0` is returned
  /// instead.
  int get selectedThemeId {
    final int id = app<ThemePreferences>().selectedTheme;

    // default to theme id 0
    return id == -1 ? 0 : id;
  }

  HarpyThemeData? _decodeThemeData(String themeDataJson) {
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
    _log.fine('loading custom themes');

    customThemes = app<ThemePreferences>()
        .customThemes
        .map(_decodeThemeData)
        .where((HarpyThemeData? themeData) => themeData != null)
        .map((HarpyThemeData? themeData) => HarpyTheme.fromData(themeData!))
        .toList();

    _log.fine('found ${customThemes.length} custom themes');
  }

  /// Updates the system ui to match the [theme].
  void updateSystemUi(HarpyTheme theme) {
    Color? navigationBarColor;

    if ((app<HarpyInfo>().deviceInfo?.version.sdkInt ?? 0) >= 30) {
      // android 11 and above allow for a transparent navigation bar where
      // the app can draw behind it
      navigationBarColor = Colors.transparent;
    } else {
      navigationBarColor = theme.backgroundColors.last;
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: theme.backgroundColors.first.withOpacity(0),
        statusBarBrightness: theme.brightness,
        statusBarIconBrightness: theme.complementaryBrightness,
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarIconBrightness: theme.complementaryBrightness,
      ),
    );
  }

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
