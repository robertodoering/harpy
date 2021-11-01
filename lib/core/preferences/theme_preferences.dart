import 'package:harpy/core/core.dart';

class ThemePreferences {
  const ThemePreferences();

  /// The id of the selected light and dark themes.
  ///
  /// - 0..9: index of predefined theme (unused indices are reserved)
  /// - 10+:  index of custom theme
  ///
  /// Defaults to 0.
  int get lightThemeId =>
      app<HarpyPreferences>().getInt('lightThemeId', 0, prefix: true);
  set lightThemeId(int value) =>
      app<HarpyPreferences>().setInt('lightThemeId', value, prefix: true);

  int get darkThemeId =>
      app<HarpyPreferences>().getInt('darkThemeId', 0, prefix: true);
  set darkThemeId(int value) =>
      app<HarpyPreferences>().setInt('darkThemeId', value, prefix: true);

  /// A list of encoded harpy theme data representing custom themes.
  List<String> get customThemes =>
      app<HarpyPreferences>().getStringList('customThemes', prefix: true);
  set customThemes(List<String?> value) => app<HarpyPreferences>()
      .setStringList('customThemes', value, prefix: true);
}
