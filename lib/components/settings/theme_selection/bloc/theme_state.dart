abstract class ThemeState {}

/// The initial state of the [ThemeBloc].
class UninitializedState extends ThemeState {}

/// The state when a theme has been selected.
class ThemeSetState extends ThemeState {}
