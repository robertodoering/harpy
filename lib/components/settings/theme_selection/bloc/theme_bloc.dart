import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:logging/logging.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({
    required this.configBloc,
  }) : super(ThemeState(
          lightThemeData: crow,
          darkThemeData: crow,
          config: configBloc.state,
          customThemesData: const [],
        )) {
    configBloc.stream.listen((config) {
      add(UpdateConfigEvent(config: config));
    });
  }

  final ConfigBloc configBloc;

  List<HarpyTheme> customThemes = <HarpyTheme>[];

  /// Returns the selected theme id based off of the [ThemePreferences].
  ///
  /// If the selected theme id is `-1` (no theme selected), `0` is returned
  /// instead.
  int get selectedThemeId {
    final id = app<ThemePreferences>().selectedTheme;

    // default to theme id 0
    return id == -1 ? 0 : id;
  }

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    yield* event.applyAsync(state: state, bloc: this);
  }
}

/// Updates the system ui to match the [theme].
void updateSystemUi(HarpyTheme theme) {
  Color navBarColor;

  final isAndroid11plus =
      (app<HarpyInfo>().deviceInfo?.version.sdkInt ?? 0) >= 30;

  if (theme.navBarColor.opacity != 1 && !isAndroid11plus) {
    // only android 11 and above allow for a transparent navigation bar where
    // the app can draw behind it
    navBarColor = theme.backgroundColors.last;
  } else {
    navBarColor = theme.navBarColor;
  }

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: theme.statusBarColor,
      statusBarBrightness: theme.brightness,
      statusBarIconBrightness: theme.statusBarIconBrightness,
      systemNavigationBarColor: navBarColor,
      systemNavigationBarIconBrightness: theme.systemNavBarIconBrightness,
    ),
  );
}
