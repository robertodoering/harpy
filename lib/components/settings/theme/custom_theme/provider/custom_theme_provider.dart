import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final _nameRegex = RegExp(r'^[a-zA-Z0-9-_ ]+$');

final customThemeProvider = StateNotifierProvider.autoDispose
    .family<CustomThemeNotifier, HarpyThemeData, int?>(
  (ref, themeId) {
    final customThemes = ref.watch(customHarpyThemesProvider);

    HarpyThemeData baseThemeData;

    if (themeId == null) {
      // creating new theme, base on currently selected theme
      baseThemeData =
          ref.read(harpyThemeProvider).data.copyWith(name: 'new theme');
    } else {
      // editing existing custom theme
      baseThemeData = customThemes[themeId - 10];
    }

    return CustomThemeNotifier(baseThemeData: baseThemeData);
  },
  name: 'CustomThemeProvider',
);

class CustomThemeNotifier extends StateNotifier<HarpyThemeData> {
  CustomThemeNotifier({
    required HarpyThemeData baseThemeData,
  })  : _baseThemeData = baseThemeData,
        super(baseThemeData);

  final HarpyThemeData _baseThemeData;

  bool get validName => _nameRegex.hasMatch(state.name);
  bool get modified => isPro && state != _baseThemeData;
  bool get canSaveTheme => mounted && modified && validName;

  bool get canAddBackgroundColor => state.backgroundColors.length < 5;
  bool get canRemoveBackgroundColor => state.backgroundColors.length > 1;
  bool get canReorderBackgroundColor => state.backgroundColors.length > 1;

  void rename(String name) {
    state = state.copyWith(name: name);
  }

  void changePrimaryColor(Color color) {
    state = state.copyWith(primaryColor: color.value);
  }

  void changeSecondaryColor(Color color) {
    state = state.copyWith(secondaryColor: color.value);
  }

  void changeCardColor(Color color) {
    state = state.copyWith(cardColor: color.value);
  }

  void changeStatusBarColor(Color color) {
    state = state.copyWith(statusBarColor: color.value);
  }

  void changeNavBarColor(Color color) {
    state = state.copyWith(navBarColor: color.value);
  }

  void changeBackgroundColor(int index, Color color) {
    final backgroundColors = List.of(state.backgroundColors);
    backgroundColors[index] = color.value;

    state = state.copyWith(backgroundColors: backgroundColors);
  }

  void addBackgroundColor() {
    final backgroundColors = List.of(state.backgroundColors)
      ..add(state.backgroundColors.last);

    state = state.copyWith(backgroundColors: backgroundColors);
  }

  void removeBackgroundColor(int index) {
    final backgroundColors = List.of(state.backgroundColors)..removeAt(index);

    state = state.copyWith(backgroundColors: backgroundColors);
  }

  void reorderBackgroundColor(int from, int to) {
    final backgroundColors = List.of(state.backgroundColors);
    backgroundColors.insert(to, backgroundColors.removeAt(from));

    state = state.copyWith(backgroundColors: backgroundColors);
  }
}
