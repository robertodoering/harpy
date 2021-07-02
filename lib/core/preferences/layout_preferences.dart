import 'package:harpy/core/core.dart';

class LayoutPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// Whether the media in a media timeline should be tiled.
  ///
  /// This is set automatically when switching the tiling mode in a media
  /// timeline rather than being accessible through a settings screen.
  bool get mediaTiled => harpyPrefs.getBool('mediaTiled', true);
  set mediaTiled(bool value) => harpyPrefs.setBool('mediaTiled', value);
}
