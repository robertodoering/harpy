part of 'custom_theme_bloc.dart';

@immutable
abstract class CustomThemeEvent {
  const CustomThemeEvent();

  Stream<CustomThemeState> applyAsync({
    required CustomThemeState currentState,
    required CustomThemeBloc bloc,
  });
}

/// Adds a background color to the [CustomThemeBloc.themeData] and initializes
/// it with the last background color.
class AddBackgroundColor extends CustomThemeEvent {
  const AddBackgroundColor();

  static final Logger _log = Logger('AddBackgroundColor');

  @override
  Stream<CustomThemeState> applyAsync({
    required CustomThemeState currentState,
    required CustomThemeBloc bloc,
  }) async* {
    _log.fine('adding new background color');

    try {
      bloc.themeData.backgroundColors.add(bloc.themeData.backgroundColors.last);
      bloc.themeBloc.updateSystemUi(bloc.harpyTheme);

      yield ModifiedCustomThemeState();
    } catch (e, st) {
      _log.warning('ignoring unexpected list state', e, st);
    }
  }
}

/// Changes a background color of the [CustomThemeBloc.themeData].
class ChangeBackgroundColor extends CustomThemeEvent {
  const ChangeBackgroundColor({
    required this.index,
    required this.color,
  });

  final int index;
  final Color color;

  static final Logger _log = Logger('ChangeBackgroundColor');

  @override
  Stream<CustomThemeState> applyAsync({
    required CustomThemeState currentState,
    required CustomThemeBloc bloc,
  }) async* {
    _log.fine('changing background color: $color at index: $index');

    try {
      bloc.themeData.backgroundColors[index] = color.value;
      bloc.themeBloc.updateSystemUi(bloc.harpyTheme);

      yield ModifiedCustomThemeState();
    } catch (e, st) {
      _log.warning('ignoring unexpected list state', e, st);
    }
  }
}

/// Removes a background color of the [CustomThemeBloc.themeData].
class RemoveBackgroundColor extends CustomThemeEvent {
  const RemoveBackgroundColor({
    required this.index,
  });

  final int index;

  static final Logger _log = Logger('RemoveBackgroundColor');

  @override
  Stream<CustomThemeState> applyAsync({
    required CustomThemeState currentState,
    required CustomThemeBloc bloc,
  }) async* {
    _log.fine('removing background color at index: $index');

    try {
      bloc.themeData.backgroundColors.removeAt(index);
      bloc.themeBloc.updateSystemUi(bloc.harpyTheme);

      yield ModifiedCustomThemeState();
    } catch (e, st) {
      _log.warning('ignoring unexpected list state', e, st);
    }
  }
}

/// Changes the index of a background color for the [CustomThemeBloc.themeData].
class ReorderBackgroundColor extends CustomThemeEvent {
  const ReorderBackgroundColor({
    required this.oldIndex,
    required this.newIndex,
  });

  final int oldIndex;
  final int newIndex;

  static final Logger _log = Logger('ReorderBackgroundColor');

  @override
  Stream<CustomThemeState> applyAsync({
    required CustomThemeState currentState,
    required CustomThemeBloc bloc,
  }) async* {
    _log.fine('reordering background color from index: $oldIndex to $newIndex');

    try {
      final color = bloc.themeData.backgroundColors[oldIndex];

      bloc.themeData.backgroundColors
        ..removeAt(oldIndex)
        ..insert(
          newIndex.clamp(0, bloc.themeData.backgroundColors.length),
          color,
        );

      bloc.themeBloc.updateSystemUi(bloc.harpyTheme);

      yield ModifiedCustomThemeState();
    } catch (e, st) {
      _log.warning('ignoring unexpected list state', e, st);
    }
  }
}

/// Changes the name of the [CustomThemeBloc.themeData].
class RenameTheme extends CustomThemeEvent {
  const RenameTheme({
    required this.name,
  });

  final String name;

  static final Logger _log = Logger('RenameTheme');

  @override
  Stream<CustomThemeState> applyAsync({
    required CustomThemeState currentState,
    required CustomThemeBloc bloc,
  }) async* {
    if (bloc.themeData.name != name) {
      _log.fine('changing name to $name');

      bloc.themeData = bloc.themeData.copyWith(name: name);

      yield ModifiedCustomThemeState();
    }
  }
}

/// Changes the accent color of the [CustomThemeBloc.themeData].
class ChangeAccentColor extends CustomThemeEvent {
  const ChangeAccentColor({
    required this.color,
  });

  final Color color;

  static final Logger _log = Logger('ChangeAccentColor');

  @override
  Stream<CustomThemeState> applyAsync({
    required CustomThemeState currentState,
    required CustomThemeBloc bloc,
  }) async* {
    _log.fine('changing accent color to $color');

    bloc.themeData = bloc.themeData.copyWith(
      accentColor: color.value,
    );

    yield ModifiedCustomThemeState();
  }
}

/// Saves the custom theme for the [CustomThemeBloc] into the
/// [ThemePreferences].
class SaveCustomTheme extends CustomThemeEvent {
  const SaveCustomTheme();

  static final Logger _log = Logger('SaveCustomTheme');

  @override
  Stream<CustomThemeState> applyAsync({
    required CustomThemeState currentState,
    required CustomThemeBloc bloc,
  }) async* {
    _log.fine('saving the custom theme with themeId ${bloc.themeId}');

    if (bloc.editingCustomTheme) {
      _log.fine('updating existing custom theme');
      bloc.themeBloc.customThemes[bloc.customThemeIndex] = bloc.harpyTheme;
    } else {
      _log.fine('adding new custom theme');
      bloc.themeBloc.customThemes.add(bloc.harpyTheme);
    }

    bloc.themeBloc
      ..add(const SaveCustomThemes())
      ..add(ChangeThemeEvent(id: bloc.themeId!, saveSelection: true));

    yield SavedCustomThemeState();

    app<HarpyNavigator>().state!.pop();
  }
}

/// Deletes the custom theme for the [CustomThemeBloc].
class DeleteCustomTheme extends CustomThemeEvent {
  const DeleteCustomTheme();

  static final Logger _log = Logger('DeleteCustomTheme');

  @override
  Stream<CustomThemeState> applyAsync({
    required CustomThemeState currentState,
    required CustomThemeBloc bloc,
  }) async* {
    _log.fine('deleting the custom theme with themeId ${bloc.themeId}');

    bloc.themeBloc.customThemes.removeAt(bloc.customThemeIndex);
    bloc.themeBloc.add(const SaveCustomThemes());

    final selectedThemeId = app<ThemePreferences>().selectedTheme;

    if (bloc.themeId == selectedThemeId) {
      // reset theme to default theme when deleting the currently selected theme
      bloc.themeBloc.add(const ChangeThemeEvent(id: 0, saveSelection: true));
    } else if (bloc.themeId! < selectedThemeId) {
      // the index of the currently selected theme changed by -1, because we
      // deleted a theme that comes before the currently selected theme
      bloc.themeBloc.add(
        ChangeThemeEvent(id: selectedThemeId - 1, saveSelection: true),
      );
    } else {
      // just reset the system ui after deleting the theme; the selected theme
      // did not change
      bloc.themeBloc.add(UpdateSystemUi(theme: bloc.themeBloc.harpyTheme));
    }

    yield DeletedCustomThemeState();

    app<HarpyNavigator>().state!.pop();
  }
}
