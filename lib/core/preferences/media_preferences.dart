import 'package:harpy/core/core.dart';

class MediaPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  final ConnectivityService connectivityService = app<ConnectivityService>();

  /// Whether the best media quality should be used.
  ///
  /// Right now this only affects the image quality because the second best
  /// video / gif quality is way worse than the best video quality.
  ///
  /// 0: always use best quality
  /// 1: only use best quality when using wifi
  /// 2: never use best quality
  int get bestMediaQuality => harpyPrefs.getInt('bestMediaQuality', 2);
  set bestMediaQuality(int value) =>
      harpyPrefs.setInt('bestMediaQuality', value);

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

  /// Whether the best media quality should be used, taking the connectivity
  /// into account.
  bool get shouldUseBestMediaQuality =>
      bestMediaQuality == 0 ||
      bestMediaQuality == 1 && connectivityService.wifi;

  /// Sets all media settings to the default settings.
  void defaultSettings() {
    bestMediaQuality = 2;
    autoplayMedia = 1;
    autoplayVideos = 2;
    openLinksExternally = false;
  }
}
