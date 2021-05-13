import 'package:harpy/core/core.dart';

class ThemePreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// The id of the selected theme.
  ///
  /// -1: no theme selected (use default)
  /// 0..9: index of predefined theme (unused indices are reserved)
  /// 10+: index of custom theme (pro only)
  int get selectedTheme => harpyPrefs.getInt('selectedTheme', -1, prefix: true);
  set selectedTheme(int value) =>
      harpyPrefs.setInt('selectedTheme', value, prefix: true);

  /// A list of encoded harpy theme data representing custom themes.
  List<String> get customThemes =>
      harpyPrefs.getStringList('customThemes', prefix: true);
  set customThemes(List<String?> value) =>
      harpyPrefs.setStringList('customThemes', value, prefix: true);
}
