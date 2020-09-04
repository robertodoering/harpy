import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_state.dart';
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

/// Adds a background color to the [CustomThemeBloc.themeData] and initializes
/// it with the last background color.
class AddBackgroundColor extends CustomThemeEvent {
  const AddBackgroundColor();

  static final Logger _log = Logger('AddBackgroundColor');

  @override
  Stream<CustomThemeState> applyAsync({
    CustomThemeState currentState,
    CustomThemeBloc bloc,
  }) async* {
    _log.fine('adding new background color');

    try {
      bloc.themeData.backgroundColors.add(bloc.themeData.backgroundColors.last);

      yield ModifiedCustomThemeState();
    } catch (e, st) {
      _log.warning('ignoring unexpected list state', e, st);
    }
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

  static final Logger _log = Logger('ChangeBackgroundColor');

  @override
  Stream<CustomThemeState> applyAsync({
    CustomThemeState currentState,
    CustomThemeBloc bloc,
  }) async* {
    _log.fine('changing background color: $color at index: $index');

    try {
      bloc.themeData.backgroundColors[index] = color.value;

      yield ModifiedCustomThemeState();
    } catch (e, st) {
      _log.warning('ignoring unexpected list state', e, st);
    }
  }
}

/// Removes a background color of the [CustomThemeBloc.themeData].
class RemoveBackgroundColor extends CustomThemeEvent {
  const RemoveBackgroundColor({
    @required this.index,
  });

  final int index;

  static final Logger _log = Logger('RemoveBackgroundColor');

  @override
  Stream<CustomThemeState> applyAsync({
    CustomThemeState currentState,
    CustomThemeBloc bloc,
  }) async* {
    _log.fine('removing background color at index: $index');

    try {
      bloc.themeData.backgroundColors.removeAt(index);

      yield ModifiedCustomThemeState();
    } catch (e, st) {
      _log.warning('ignoring unexpected list state', e, st);
    }
  }
}

/// Changes the index of a background color for the [CustomThemeBloc.themeData].
class ReorderBackgroundColor extends CustomThemeEvent {
  const ReorderBackgroundColor({
    @required this.oldIndex,
    @required this.newIndex,
  });

  final int oldIndex;
  final int newIndex;

  static final Logger _log = Logger('ReorderBackgroundColor');

  @override
  Stream<CustomThemeState> applyAsync({
    CustomThemeState currentState,
    CustomThemeBloc bloc,
  }) async* {
    _log.fine('reordering background color from index: $oldIndex to $newIndex');

    try {
      final int color = bloc.themeData.backgroundColors[oldIndex];

      bloc.themeData.backgroundColors
        ..removeAt(oldIndex)
        ..insert(newIndex, color);

      yield ModifiedCustomThemeState();
    } catch (e, st) {
      _log.warning('ignoring unexpected list state', e, st);
    }
  }
}

/// Changes the name of the [CustomThemeBloc.themeData].
class RenameTheme extends CustomThemeEvent {
  const RenameTheme({
    @required this.name,
  });

  final String name;

  static final Logger _log = Logger('RenameTheme');

  @override
  Stream<CustomThemeState> applyAsync({
    CustomThemeState currentState,
    CustomThemeBloc bloc,
  }) async* {
    if (bloc.themeData.name != name) {
      _log.fine('changing name to $name');

      bloc.themeData.name = name;

      yield ModifiedCustomThemeState();
    }
  }
}
