import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

final _nameRegex = RegExp(r'^[a-zA-Z0-9-_ ]+$');

/// Handles creating and modifying custom themes.
class CustomThemeCubit extends Cubit<HarpyThemeData> with HarpyLogger {
  CustomThemeCubit({
    required this.initialThemeData,
    required this.themeId,
    required Config config,
  }) : super(initialThemeData) {
    harpyTheme = HarpyTheme.fromData(data: state, config: config);

    stream.listen((event) {
      harpyTheme = HarpyTheme.fromData(data: state, config: config);
    });
  }

  final HarpyThemeData initialThemeData;
  final int themeId;

  late HarpyTheme harpyTheme;

  bool get validName => _nameRegex.hasMatch(state.name);
  bool get modifiedTheme => isPro && state != initialThemeData;
  bool get canSaveTheme => modifiedTheme && validName;

  bool get canAddBackgroundColor => state.backgroundColors.length < 5;
  bool get canRemoveBackgroundColor => state.backgroundColors.length > 1;
  bool get canReorderBackgroundColor => state.backgroundColors.length > 1;

  void renameTheme(String name) {
    if (state.name != name) {
      log.fine('changing name to $name');

      emit(state.copyWith(name: name));
    }
  }

  void changePrimaryColor(Color color) {
    emit(state.copyWith(primaryColor: color.value));
  }

  void changeSecondaryColor(Color color) {
    emit(state.copyWith(secondaryColor: color.value));
  }

  void changeCardColor(Color color) {
    emit(state.copyWith(cardColor: color.value));
  }

  void changeStatusBarColor(Color color) {
    emit(state.copyWith(statusBarColor: color.value));

    updateSystemUi(harpyTheme);
  }

  void changeNavBarColor(Color color) {
    emit(state.copyWith(navBarColor: color.value));

    updateSystemUi(harpyTheme);
  }

  void changeBackgroundColor(int index, Color color) {
    final backgroundColors = List.of(state.backgroundColors);
    backgroundColors[index] = color.value;

    emit(
      state.copyWith(
        backgroundColors: backgroundColors,
      ),
    );
  }

  void addBackgroundColor() {
    if (!canAddBackgroundColor) {
      return;
    }

    log.fine('adding background color');

    emit(
      state.copyWith(
        backgroundColors: [
          ...state.backgroundColors,
          state.backgroundColors.last,
        ],
      ),
    );

    updateSystemUi(harpyTheme);
  }

  void removeBackgroundColor(int index) {
    if (!canRemoveBackgroundColor) {
      return;
    }

    log.fine('removing background color at $index');

    try {
      emit(
        state.copyWith(
          backgroundColors: List.of(state.backgroundColors)..removeAt(index),
        ),
      );

      updateSystemUi(harpyTheme);
    } catch (e, st) {
      log.warning('unexpected list state', e, st);
    }
  }

  void reorderBackgroundColor(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) {
      return;
    }

    log.fine('reordering background color from $fromIndex to $toIndex');

    try {
      final color = state.backgroundColors[fromIndex];

      emit(
        state.copyWith(
          backgroundColors: List.of(state.backgroundColors)
            ..removeAt(fromIndex)
            ..insert(toIndex, color),
        ),
      );

      updateSystemUi(harpyTheme);
    } catch (e, st) {
      log.warning('unexpected list state', e, st);
    }
  }
}
