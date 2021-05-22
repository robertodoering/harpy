import 'package:harpy/core/core.dart';

class LayoutPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// Whether a compact layout should be used.
  bool get compactMode => harpyPrefs.getBool('compactMode', false);
  set compactMode(bool value) => harpyPrefs.setBool('compactMode', value);

  /// Whether the media in a media timeline should be tiled.
  ///
  /// This is set automatically when switching the tiling mode in a media
  /// timeline rather than being accessible through a settings screen.
  bool get mediaTiled => harpyPrefs.getBool('mediaTiled', true);
  set mediaTiled(bool value) => harpyPrefs.setBool('mediaTiled', value);

  double get fontSizeDelta {
    final delta = harpyPrefs.getInt('fontSizeDelta', 0);

    //TODO create and use general mapping
    switch (delta) {
      case -1:
        return -2;
      case -2:
        return -4;
      case 1:
        return 2;
      case 2:
        return 4;
      case 0:
      default:
        return 0;
    }
  }

  set fontSizeDelta(double fontSizeDelta) {
    var fontSizeDetaid = 0;

    //TODO create and use general mapping
    if (fontSizeDelta == -2) {
      fontSizeDetaid = -1;
    } else if (fontSizeDelta == -4) {
      fontSizeDetaid = -2;
    } else if (fontSizeDelta == 2) {
      fontSizeDetaid = 1;
    } else if (fontSizeDelta == 4) {
      fontSizeDetaid = 2;
    }

    harpyPrefs.setInt('fontSizeDelta', fontSizeDetaid);
  }

  /// Sets all layout settings to the default settings.
  void defaultSettings() {
    compactMode = false;
  }
}
