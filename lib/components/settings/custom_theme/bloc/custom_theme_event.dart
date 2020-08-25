import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_state.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CustomThemeEvent {
  const CustomThemeEvent();

  Stream<CustomThemeState> applyAsync({
    CustomThemeState currentState,
    CustomThemeBloc bloc,
  });
}
