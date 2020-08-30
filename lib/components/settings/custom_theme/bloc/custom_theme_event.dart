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

/// Adds a background color to the [CustomThemeBloc.themeData] and initializes
/// it with the last background color.
class AddBackgroundColor extends CustomThemeEvent {
  const AddBackgroundColor();

  @override
  Stream<CustomThemeState> applyAsync({
    CustomThemeState currentState,
    CustomThemeBloc bloc,
  }) async* {
    bloc.themeData.backgroundColors.add(bloc.themeData.backgroundColors.last);

    yield ModifiedCustomThemeState();
  }
}

/// Changes a background color of the [CustomThemeBloc.themeData].
class ChangeBackgroundColor extends CustomThemeEvent {
  const ChangeBackgroundColor({
    @required this.index,
    @required this.color,
  });

  final int index;

  final Color color;

  @override
  Stream<CustomThemeState> applyAsync({
    CustomThemeState currentState,
    CustomThemeBloc bloc,
  }) async* {
    bloc.themeData.backgroundColors[index] = color.value;

    yield ModifiedCustomThemeState();
  }
}

/// Removes a background color of the [CustomThemeBloc.themeData].
class RemoveBackgroundColor extends CustomThemeEvent {
  const RemoveBackgroundColor({
    @required this.index,
  });

  final int index;

  @override
  Stream<CustomThemeState> applyAsync({
    CustomThemeState currentState,
    CustomThemeBloc bloc,
  }) async* {
    bloc.themeData.backgroundColors.removeAt(index);

    yield ModifiedCustomThemeState();
  }
}

/// Changes the index of a background color.
class ReorderBackgroundColor extends CustomThemeEvent {
  const ReorderBackgroundColor({
    @required this.oldIndex,
    @required this.newIndex,
  });

  final int oldIndex;
  final int newIndex;

  @override
  Stream<CustomThemeState> applyAsync({
    CustomThemeState currentState,
    CustomThemeBloc bloc,
  }) async* {
    final int color = bloc.themeData.backgroundColors[oldIndex];

    bloc.themeData.backgroundColors
      ..removeAt(oldIndex)
      ..insert(newIndex, color);

    yield ModifiedCustomThemeState();
  }
}
