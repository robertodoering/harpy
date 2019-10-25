import 'package:flutter/material.dart';
import 'package:harpy/core/misc/connectivity_service.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:harpy/harpy.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class MediaSettingsModel extends ChangeNotifier {
  final HarpyPrefs harpyPrefs = app<HarpyPrefs>();
  final ConnectivityService connectivityService = app<ConnectivityService>();

  static MediaSettingsModel of(BuildContext context) {
    return Provider.of<MediaSettingsModel>(context);
  }

  static final Logger _log = Logger("MediaSettingsModel");

  /// Returns the quality, taking the connectivity into consideration.
  int get quality =>
      connectivityService.wifi ? wifiMediaQuality : nonWifiMediaQuality;

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

  /// Whether or not to autoplay gifs.
  ///
  /// 0: always autoplay
  /// 1: only autoplay when using wifi
  /// 2: never autoplay
  int get autoplayMedia => harpyPrefs.getInt("autoplayMedia", 0, 0, 2);

  /// Whether or not to always open links externally instead of an internal
  /// web view.
  bool get openLinksExternally =>
      harpyPrefs.getBool("openLinksExternally", false);

  /// Returns `false` when always hiding media initially.
  bool get enableAutoplayMedia => defaultHideMedia != 2;

  /// Sets all media settings to the default settings.
  void defaultSettings() {
    _log.fine("resetting media settings");
    changeWifiMediaQuality(0);
    changeNonWifiMediaQuality(0);
    changeDefaultHideMedia(0);
    changeAutoplayMedia(1);
    changeOpenLinksExternally(false);
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

  /// Changes whether or not to autoplay gifs.
  void changeAutoplayMedia(int value) {
    harpyPrefs.preferences.setInt("autoplayMedia", value);
    notifyListeners();
  }

  /// Changes whether or not to always open links externally.
  void changeOpenLinksExternally(bool value) {
    harpyPrefs.preferences.setBool("openLinksExternally", value);
    notifyListeners();
  }
}
