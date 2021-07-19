import 'package:harpy/core/core.dart';

class ThemePreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// The id of the selected light and dark themes.
  ///
  /// - 0..9: index of predefined theme (unused indices are reserved)
  /// - 10+:  index of custom theme
  ///
  /// Defaults to 0.
  int get lightThemeId => harpyPrefs.getInt('lightThemeId', 0, prefix: true);
  set lightThemeId(int value) =>
      harpyPrefs.setInt('lightThemeId', value, prefix: true);

  int get darkThemeId => harpyPrefs.getInt('darkThemeId', 0, prefix: true);
  set darkThemeId(int value) =>
      harpyPrefs.setInt('darkThemeId', value, prefix: true);

  /// A list of encoded harpy theme data representing custom themes.
  List<String> get customThemes =>
      harpyPrefs.getStringList('customThemes', prefix: true);
  set customThemes(List<String?> value) =>
      harpyPrefs.setStringList('customThemes', value, prefix: true);
}
