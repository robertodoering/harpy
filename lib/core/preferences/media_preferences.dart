import 'package:harpy/core/connectivity_service.dart';
import 'package:harpy/core/preferences/harpy_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class MediaPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  final ConnectivityService connectivityService = app<ConnectivityService>();

  /// The media quality when using wifi.
  ///
  /// 0: large
  /// 1: medium
  /// 2: small
  int get wifiMediaQuality =>
      harpyPrefs.getInt('wifiMediaQuality', 0, lowerLimit: 0, upperLimit: 2);
  set wifiMediaQuality(int value) =>
      harpyPrefs.setInt('wifiMediaQuality', value);

  /// The media quality when not using wifi.
  ///
  /// 0: large
  /// 1: medium
  /// 2: small
  int get nonWifiMediaQuality =>
      harpyPrefs.getInt('nonWifiMediaQuality', 0, lowerLimit: 0, upperLimit: 2);
  set nonWifiMediaQuality(int value) =>
      harpyPrefs.setInt('nonWifiMediaQuality', value);

  /// Whether gifs should play automatically.
  ///
  /// 0: always autoplay
  /// 1: only autoplay when using wifi
  /// 2: never autoplay
  int get autoplayMedia =>
      harpyPrefs.getInt('autoplayMedia', 1, lowerLimit: 0, upperLimit: 2);
  set autoplayMedia(int value) => harpyPrefs.setInt('autoplayMedia', value);

  /// Whether videos should play automatically.
  ///
  /// 0: always autoplay
  /// 1: only autoplay when using wifi
  /// 2: never autoplay
  int get autoplayVideos =>
      harpyPrefs.getInt('autoplayVideos', 2, lowerLimit: 0, upperLimit: 2);
  set autoplayVideos(int value) => harpyPrefs.setInt('autoplayVideos', value);

  /// Whether links should open externally instead of using a built in web view.
  bool get openLinksExternally =>
      harpyPrefs.getBool('openLinksExternally', false);
  set openLinksExternally(bool value) =>
      harpyPrefs.setBool('openLinksExternally', value);

  /// Whether gifs should play automatically, taking the connectivity into
  /// account.
  bool get shouldAutoplayMedia =>
      autoplayMedia == 0 || autoplayMedia == 1 && connectivityService.wifi;

  /// Whether videos should play automatically, taking the connectivity into
  /// account.
  bool get shouldAutoplayVideos =>
      autoplayVideos == 0 || autoplayVideos == 1 && connectivityService.wifi;

  /// The media quality, taking the connectivity into account.
  int get appropriateMediaQuality =>
      connectivityService.wifi ? wifiMediaQuality : nonWifiMediaQuality;

  /// Sets all media settings to the default settings.
  void defaultSettings() {
    wifiMediaQuality = 0;
    nonWifiMediaQuality = 0;
    autoplayMedia = 1;
    autoplayVideos = 2;
    openLinksExternally = false;
  }
}
