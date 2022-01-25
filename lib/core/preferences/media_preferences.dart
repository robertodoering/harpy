import 'package:harpy/core/core.dart';

class MediaPreferences {
  const MediaPreferences();

  /// Whether the best media quality should be used.
  ///
  /// Right now this only affects the image quality because the second best
  /// video / gif quality is way worse than the best video quality.
  ///
  /// 0: always use best quality
  /// 1: only use best quality when using wifi
  /// 2: never use best quality
  int get bestMediaQuality =>
      app<HarpyPreferences>().getInt('bestMediaQuality', 2);
  set bestMediaQuality(int value) =>
      app<HarpyPreferences>().setInt('bestMediaQuality', value);

  /// Whether the image height of a tweet with a single image should be
  /// constrained to a 16 / 9 aspect ratio.
  bool get cropImage => app<HarpyPreferences>().getBool('cropImage', false);
  set cropImage(bool value) =>
      app<HarpyPreferences>().setBool('cropImage', value);

  /// Whether gifs should play automatically.
  ///
  /// 0: always autoplay
  /// 1: only autoplay when using wifi
  /// 2: never autoplay
  int get autoplayMedia => app<HarpyPreferences>()
      .getInt('autoplayMedia', 1, lowerLimit: 0, upperLimit: 2);
  set autoplayMedia(int value) =>
      app<HarpyPreferences>().setInt('autoplayMedia', value);

  /// Whether videos should play automatically.
  ///
  /// 0: always autoplay
  /// 1: only autoplay when using wifi
  /// 2: never autoplay
  int get autoplayVideos => app<HarpyPreferences>()
      .getInt('autoplayVideos', 2, lowerLimit: 0, upperLimit: 2);
  set autoplayVideos(int value) =>
      app<HarpyPreferences>().setInt('autoplayVideos', value);

  /// Whether links should open externally instead of using a built in web view.
  bool get openLinksExternally =>
      app<HarpyPreferences>().getBool('openLinksExternally', false);
  set openLinksExternally(bool value) =>
      app<HarpyPreferences>().setBool('openLinksExternally', value);

  /// Whether the download dialog should show when downloading media.
  bool get showDownloadDialog =>
      app<HarpyPreferences>().getBool('showDownloadDialog', true);
  set showDownloadDialog(bool value) =>
      app<HarpyPreferences>().setBool('showDownloadDialog', value);

  /// Encoded download path data that maps a media type with its download path.
  String get downloadPathData =>
      app<HarpyPreferences>().getString('downloadPathData', '');
  set downloadPathData(String value) =>
      app<HarpyPreferences>().setString('downloadPathData', value);

  /// Whether gifs should play automatically, taking the connectivity into
  /// account.
  bool get shouldAutoplayMedia =>
      autoplayMedia == 0 ||
      autoplayMedia == 1 && app<ConnectivityService>().wifi;

  /// Whether videos should play automatically, taking the connectivity into
  /// account.
  bool get shouldAutoplayVideos =>
      autoplayVideos == 0 ||
      autoplayVideos == 1 && app<ConnectivityService>().wifi;

  /// Whether the best media quality should be used, taking the connectivity
  /// into account.
  bool get shouldUseBestMediaQuality =>
      bestMediaQuality == 0 ||
      bestMediaQuality == 1 && app<ConnectivityService>().wifi;

  /// Sets all media settings to the default settings.
  void defaultSettings() {
    bestMediaQuality = 2;
    cropImage = false;
    autoplayMedia = 1;
    autoplayVideos = 2;
    openLinksExternally = false;
    downloadPathData = '';
    showDownloadDialog = true;
  }
}
