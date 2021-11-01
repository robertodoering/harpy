import 'package:harpy/core/core.dart';

class LayoutPreferences {
  const LayoutPreferences();

  /// Whether the media in a media timeline should be tiled.
  ///
  /// This is set automatically when switching the tiling mode in a media
  /// timeline rather than being accessible through a settings screen.
  bool get mediaTiled => app<HarpyPreferences>().getBool('mediaTiled', true);
  set mediaTiled(bool value) =>
      app<HarpyPreferences>().setBool('mediaTiled', value);

  /// The id of the tab that is used by the harpy color picker.
  int get colorPickerTab => app<HarpyPreferences>().getInt('colorPickerTab', 0);
  set colorPickerTab(int value) =>
      app<HarpyPreferences>().setInt('colorPickerTab', value);
}
