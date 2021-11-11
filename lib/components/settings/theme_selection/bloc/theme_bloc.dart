import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
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
  }) : super(
          ThemeState(
            lightThemeData: predefinedThemes.first,
            darkThemeData: predefinedThemes.first,
            config: configCubit.state,
            customThemesData: const [],
          ),
        ) {
    on<ThemeEvent>((event, emit) => event.handle(this, emit));

    configCubit.stream.listen((config) {
      add(UpdateThemeConfig(config: config));
    });
  }

  final ConfigCubit configCubit;
}

/// Updates the system ui to match the [theme].
void updateSystemUi(HarpyTheme theme) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: theme.statusBarColor,
      statusBarBrightness: theme.statusBarBrightness,
      statusBarIconBrightness: theme.statusBarIconBrightness,
      systemNavigationBarColor: theme.navBarColor,
      systemNavigationBarDividerColor: theme.navBarColor,
      systemNavigationBarIconBrightness: theme.navBarIconBrightness,
    ),
  );
}
