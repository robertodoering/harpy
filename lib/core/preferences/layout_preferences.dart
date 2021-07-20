import 'package:harpy/core/core.dart';

class LayoutPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// Whether the media in a media timeline should be tiled.
  ///
  /// This is set automatically when switching the tiling mode in a media
  /// timeline rather than being accessible through a settings screen.
  bool get mediaTiled => harpyPrefs.getBool('mediaTiled', true);
  set mediaTiled(bool value) => harpyPrefs.setBool('mediaTiled', value);

  /// The id of the tab that is used by the harpy color picker.
  int get colorPickerTab => harpyPrefs.getInt('colorPickerTab', 0);
  set colorPickerTab(int value) => harpyPrefs.setInt('colorPickerTab', value);
}
