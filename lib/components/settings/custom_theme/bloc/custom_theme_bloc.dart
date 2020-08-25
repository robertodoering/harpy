import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_theme_event.dart';
import 'custom_theme_state.dart';

/// Handles creating and modifying custom themes.
class CustomThemeBloc extends Bloc<CustomThemeEvent, CustomThemeState> {
  CustomThemeBloc() : super(UninitializedState());

  static CustomThemeBloc of(BuildContext context) =>
      BlocProvider.of<CustomThemeBloc>(context);

  @override
  Stream<CustomThemeState> mapEventToState(
    CustomThemeEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
