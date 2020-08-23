import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/settings/bloc/custom_theme/custom_theme_event.dart';
import 'package:harpy/components/settings/bloc/custom_theme/custom_theme_state.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Loads custom themes and handles saving and modifying custom themes.
class CustomThemeBloc extends Bloc<CustomThemeEvent, CustomThemeState> {
  CustomThemeBloc() : super(UninitializedState());

  /// The list of custom themes.
  List<HarpyTheme> customThemes = <HarpyTheme>[];

  /// Completes when the custom themes have been loaded using
  /// [LoadCustomThemesEvent].
  Completer<void> loadCustomThemesCompleter = Completer<void>();

  static CustomThemeBloc of(BuildContext context) =>
      BlocProvider.of<CustomThemeBloc>(context);

  @override
  Stream<CustomThemeState> mapEventToState(
    CustomThemeEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
