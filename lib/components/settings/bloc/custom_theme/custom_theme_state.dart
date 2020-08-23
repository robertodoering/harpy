abstract class CustomThemeState {}

/// The state when the custom themes have not been loaded.
class UninitializedState extends CustomThemeState {}

/// The state when the custom themes for the active user have been loaded.
class InitializedState extends CustomThemeState {}
