import 'package:harpy/core/preferences/harpy_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class MediaPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// The media quality when using wifi.
  ///
  /// 0: large
  /// 1: medium
  /// 2: small
  int get wifiMediaQuality => harpyPrefs.getInt('wifiMediaQuality', 0, 0, 2);
  set wifiMediaQuality(int value) =>
      harpyPrefs.setInt('wifiMediaQuality', value);

  /// The media quality when not using wifi.
  ///
  /// 0: large
  /// 1: medium
  /// 2: small
  int get nonWifiMediaQuality =>
      harpyPrefs.getInt('nonWifiMediaQuality', 0, 0, 2);
  set nonWifiMediaQuality(int value) =>
      harpyPrefs.setInt('nonWifiMediaQuality', value);

  /// Whether the media should be hidden by default
  ///
  /// 0: always show
  /// 1: only show when using wifi
  /// 2: always hide
  int get defaultHideMedia => harpyPrefs.getInt('defaultHideMedia', 0, 0, 2);
  set defaultHideMedia(int value) =>
      harpyPrefs.setInt('defaultHideMedia', value);

  /// Whether gifs should play automatically.
  ///
  /// 0: always autoplay
  /// 1: only autoplay when using wifi
  /// 2: never autoplay
  int get autoplayMedia => harpyPrefs.getInt('autoplayMedia', 1, 0, 2);
  set autoplayMedia(int value) => harpyPrefs.setInt('autoplayMedia', value);

  /// Whether links should open externally instead of using a built in web view.
  bool get openLinksExternally =>
      harpyPrefs.getBool('openLinksExternally', false);
  set openLinksExternally(bool value) =>
      harpyPrefs.setBool('openLinksExternally', value);

  /// Sets all media settings to the default settings.
  void defaultSettings() {
    wifiMediaQuality = 0;
    nonWifiMediaQuality = 0;
    defaultHideMedia = 0;
    autoplayMedia = 1;
    openLinksExternally = false;
  }
}
