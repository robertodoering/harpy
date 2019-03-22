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

  /// The default media quality when using wifi.
  ///
  /// 0: large
  /// 1: medium
  /// 2: small
  int get wifiMediaQuality => harpyPrefs.getInt("wifiMediaQuality", 0, 0, 2);

  /// The default media quality when not using wifi.
  ///
  /// 0: large
  /// 1: medium
  /// 2: small
  int get nonWifiMediaQuality =>
      harpyPrefs.getInt("nonWifiMediaQuality", 0, 0, 2);

  /// Whether or not to hide the media by default.
  ///
  /// 0: always show
  /// 1: only show when using wifi
  /// 2: always hide
  int get defaultHideMedia => harpyPrefs.getInt("defaultHideMedia", 0, 0, 2);

  /// Whether or not to autoplay videos and gifs.
  ///
  /// 0: always autoplay
  /// 1: only autoplay when using wifi
  /// 2: never autoplay
  int get autoplayMedia => harpyPrefs.getInt("autoplayMedia", 0, 0, 2);

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
  void changeWifiMediaQuality(int value) {
    harpyPrefs.preferences.setInt("wifiMediaQuality", value);
    notifyListeners();
  }

  /// Changes the default media quality when not using wifi.
  void changeNonWifiMediaQuality(int value) {
    harpyPrefs.preferences.setInt("nonWifiMediaQuality", value);
    notifyListeners();
  }

  /// Changes whether or not to hide the media by default.
  void changeDefaultHideMedia(int value) {
    harpyPrefs.preferences.setInt("defaultHideMedia", value);
    notifyListeners();
  }

  /// Changes whether or not to autoplay videos and gifs.
  void changeAutoplayMedia(int value) {
    harpyPrefs.preferences.setInt("autoplayMedia", value);
    notifyListeners();
  }
}
