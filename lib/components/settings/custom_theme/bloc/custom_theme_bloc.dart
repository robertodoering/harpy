import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/harpy_theme_data.dart';

import 'custom_theme_event.dart';
import 'custom_theme_state.dart';

/// Handles creating and modifying custom themes.
class CustomThemeBloc extends Bloc<CustomThemeEvent, CustomThemeState> {
  CustomThemeBloc({
    @required this.themeData,
    @required this.themeId,
  }) : super(UnchangedCustomThemeState());

  /// The [HarpyThemeData] for the theme customization.
  HarpyThemeData themeData;

  /// Returns the [themeData] as a [HarpyTheme].
  HarpyTheme get harpyTheme => HarpyTheme.fromData(themeData);

  /// The id of this custom theme, starting at 10 for the first custom theme.
  int themeId;

  static CustomThemeBloc of(BuildContext context) =>
      BlocProvider.of<CustomThemeBloc>(context);

  /// Whether more background colors can be added.
  bool get canAddMoreBackgroundColors => themeData.backgroundColors.length < 5;

  /// Whether background colors can be removed.
  bool get canRemoveBackgroundColor => themeData.backgroundColors.length > 1;

  /// Whether the name only contains alphanumeric characters, '-', '_' and
  /// spaces.
  bool get validName =>
      themeData.name.isNotEmpty &&
      themeData.name.contains(RegExp(r'^[-_ a-zA-Z0-9]+$'));

  @override
  Stream<CustomThemeState> mapEventToState(
    CustomThemeEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
