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

  final Map<int, double> _fontSizeDeltaIdMapping = <int, double>{
    0: 0,
    -1: -2,
    -2: -4,
    1: 2,
    2: 4,
  };

  final Map<int, String> _fontSizeDeltaIdNameMapping = <int, String>{
    0: 'normal',
    -1: 'small',
    -2: 'smallest',
    1: 'big',
    2: 'biggest',
  };

  double get minFontSizeDelta => -4;
  double get maxFontSizeDelta => 4;

  String get currentFontSizeDeltaName {
    final deltaId = harpyPrefs.getInt('fontSizeDelta', 0);
    return _fontSizeDeltaIdNameMapping[deltaId] ?? 'normal';
  }

  double get fontSizeDelta {
    final deltaId = harpyPrefs.getInt('fontSizeDelta', 0);

    return _fontSizeDeltaIdMapping[deltaId] ?? 0;
  }

  set fontSizeDelta(double fontSizeDelta) {
    var fontSizeDeltaId = 0;

    final isPresentDelta =
        _fontSizeDeltaIdMapping.containsValue(fontSizeDeltaId);

    if (isPresentDelta) {
      final entry = _fontSizeDeltaIdMapping.entries
          .firstWhere((element) => element.value == fontSizeDelta);

      fontSizeDeltaId = entry.key;
    }

    harpyPrefs.setInt('fontSizeDelta', fontSizeDeltaId);
  }

  /// Sets all layout settings to the default settings.
  void defaultSettings() {
    compactMode = false;
    fontSizeDelta = 0;
  }
}
