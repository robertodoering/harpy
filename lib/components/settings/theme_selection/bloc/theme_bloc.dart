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

/// Handles changing the light and dark themes and loading + updating custom
/// theme data.
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({
    required this.configCubit,
  }) : super(ThemeState(
          lightThemeData: crow,
          darkThemeData: crow,
          config: configCubit.state,
          customThemesData: const [],
        )) {
    configCubit.stream.listen((config) {
      add(UpdateThemeConfig(config: config));
    });
  }

  final ConfigCubit configCubit;

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
    navBarColor = theme.navBarColor.withOpacity(1);
  } else {
    navBarColor = theme.navBarColor;
  }

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: theme.statusBarColor,
      statusBarBrightness: theme.statusBarBrightness,
      statusBarIconBrightness: theme.statusBarIconBrightness,
      systemNavigationBarColor: navBarColor,
      systemNavigationBarDividerColor: navBarColor,
      systemNavigationBarIconBrightness: theme.navBarIconBrightness,
    ),
  );
}
