import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:logging/logging.dart';

part 'custom_theme_event.dart';
part 'custom_theme_state.dart';

/// Handles creating and editing custom themes.
class CustomThemeBloc extends Bloc<CustomThemeEvent, CustomThemeState> {
  CustomThemeBloc({
    required this.themeData,
    required this.themeId,
    required this.themeBloc,
  }) : super(UnchangedCustomThemeState());

  final ThemeBloc themeBloc;

  /// The [HarpyThemeData] for the theme customization.
  HarpyThemeData themeData;

  /// The id of this custom theme, starting at 10 for the first custom theme.
  int? themeId;

  /// The index for this custom theme based on the `themeId`.
  int get customThemeIndex => themeId! - 10;

  /// Returns the [themeData] as a [HarpyTheme].
  HarpyTheme get harpyTheme => HarpyTheme.fromData(themeData);

  static CustomThemeBloc of(BuildContext context) =>
      context.watch<CustomThemeBloc>();

  /// Whether more background colors can be added.
  bool get canAddMoreBackgroundColors => themeData.backgroundColors!.length < 5;

  /// Whether background colors can be removed.
  bool get canRemoveBackgroundColor => themeData.backgroundColors!.length > 1;

  /// Whether the name only contains alphanumeric characters, '-', '_' and
  /// spaces.
  bool get validName =>
      themeData.name!.isNotEmpty &&
      themeData.name!.contains(RegExp(r'^[-_ a-zA-Z0-9]+$'));

  /// Whether the accent color provides enough contrast for text on the
  /// background.
  bool get accentColorContrasts =>
      HarpyTheme.contrastRatio(
        harpyTheme.accentColor.computeLuminance(),
        harpyTheme.backgroundLuminance,
      ) >=
      kTextContrastRatio;

  /// Whether the custom theme can be saved.
  bool get canSaveTheme => state is ModifiedCustomThemeState && Harpy.isPro;

  /// Whether this custom theme is an existing theme that is being edited or a
  /// newly added theme.
  bool get editingCustomTheme =>
      customThemeIndex < themeBloc.customThemes.length;

  @override
  Stream<CustomThemeState> mapEventToState(
    CustomThemeEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
