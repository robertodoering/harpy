part of 'custom_theme_bloc.dart';

@immutable
abstract class CustomThemeState {}

/// The initial state where a custom theme has not yet been modified.
class UnchangedCustomThemeState extends CustomThemeState {}

/// The state after the custom theme has been modified.
class ModifiedCustomThemeState extends CustomThemeState {}

/// The state after the custom theme has been saved.
class SavedCustomThemeState extends CustomThemeState {}

/// The state after the custom theme has been deleted.
class DeletedCustomThemeState extends CustomThemeState {}
