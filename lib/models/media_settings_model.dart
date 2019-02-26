import 'package:flutter/material.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';

class MediaSettingsModel extends Model {
  MediaSettingsModel({
    @required this.harpyPrefs,
  }) : assert(harpyPrefs != null);

  final HarpyPrefs harpyPrefs;

  static MediaSettingsModel of(BuildContext context) {
    return ScopedModel.of<MediaSettingsModel>(context);
  }

  static final Logger _log = Logger("MediaSettingsModel");

  // clamp between lowest and highest possible value
  int get wifiMediaQuality => _getInt("wifiMediaQuality", 0, 0, 3);
  int get nonWifiMediaQuality => _getInt("nonWifiMediaQuality", 0, 0, 3);
  int get defaultHideMedia => _getInt("defaultHideMedia", 0, 0, 2);
  int get autoplayMedia => _getInt("autoplayMedia", 0, 0, 2);

  /// Returns `false` when always hiding media initially.
  bool get enableAutoplayMedia => defaultHideMedia != 2;

  /// Sets all media settings to the default settings.
  void defaultSettings() {
    _log.fine("resetting media settings");
    changeWifiMediaQuality(0);
    changeNonWifiMediaQuality(0);
    changeDefaultHideMedia(0);
    changeAutoplayMedia(1);
  }

  /// Changes the default media quality when using wifi.
  ///
  /// // todo: check quality options in media
  /// 0: highest
  /// 1: high
  /// 2: low
  /// 3: lowest
  void changeWifiMediaQuality(int value) {
    harpyPrefs.preferences.setInt("wifiMediaQuality", value);
    notifyListeners();
  }

  /// Changes the default media quality when not using wifi.
  ///
  /// 0: highest
  /// 1: high
  /// 2: low
  /// 3: lowest
  void changeNonWifiMediaQuality(int value) {
    harpyPrefs.preferences.setInt("nonWifiMediaQuality", value);
    notifyListeners();
  }

  /// Changes whether or not to hide the media by default.
  ///
  /// 0: always show
  /// 1: only show when using wifi
  /// 2: always hide
  void changeDefaultHideMedia(int value) {
    harpyPrefs.preferences.setInt("defaultHideMedia", value);
    notifyListeners();
  }

  /// Changes whether or not to autoplay videos and gifs.
  ///
  /// 0: always autoplay
  /// 1: only autoplay when using wifi
  /// 2: never autoplay
  void changeAutoplayMedia(int value) {
    harpyPrefs.preferences.setInt("autoplayMedia", value);
    notifyListeners();
  }

  int _getInt(String key, int defaultValue, int lowerLimit, int upperLimit) {
    try {
      return (harpyPrefs.preferences.getInt(key) ?? defaultValue)
          .clamp(lowerLimit, upperLimit);
    } catch (e) {
      return defaultValue;
    }
  }
}
