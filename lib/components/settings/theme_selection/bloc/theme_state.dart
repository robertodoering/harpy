abstract class ThemeState {}

/// The initial state of the [ThemeBloc].
class UninitializedState extends ThemeState {}

/// The state when a theme has been selected.
///
/// Yielded by the [ChangeThemeEvent].
///
/// This state is being yielded consecutively whenever the theme is being
/// changed.
class ThemeSetState extends ThemeState {}
