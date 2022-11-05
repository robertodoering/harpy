import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

part 'media_preferences.freezed.dart';

final mediaPreferencesProvider =
    StateNotifierProvider<MediaPreferencesNotifier, MediaPreferences>(
  (ref) => MediaPreferencesNotifier(
    preferences: ref.watch(preferencesProvider(null)),
  ),
  name: 'MediaPreferencesProvider',
);

class MediaPreferencesNotifier extends StateNotifier<MediaPreferences> {
  MediaPreferencesNotifier({
    required Preferences preferences,
  })  : _preferences = preferences,
        super(
          MediaPreferences(
            bestMediaQuality: preferences.getInt('bestMediaQuality', 2),
            cropImage: preferences.getBool('cropImage', false),
            autoplayGifs: preferences.getInt('autoplayMedia', 1),
            autoplayVideos: preferences.getInt('autoplayVideos', 2),
            startVideoPlaybackMuted: preferences.getBool(
              'startVideoPlaybackMuted',
              false,
            ),
            hidePossiblySensitive: preferences.getBool(
              'hidePossiblySensitive',
              false,
            ),
            openLinksExternally: preferences.getBool(
              'openLinksExternally',
              false,
            ),
            showDownloadDialog: preferences.getBool('showDownloadDialog', true),
            downloadPathData: preferences.getString('downloadPathData', ''),
          ),
        );

  final Preferences _preferences;

  void defaultSettings() {
    setBestMediaQuality(2);
    setCropImage(false);
    setAutoplayGifs(1);
    setAutoplayVideos(2);
    setStartVideoPlaybackMuted(false);
    setHidePossiblySensitive(false);
    setOpenLinksExternally(false);
    setShowDownloadDialog(true);
    setDownloadPathData('');
  }

  void setBestMediaQuality(int value) {
    state = state.copyWith(bestMediaQuality: value);
    _preferences.setInt('bestMediaQuality', value);
  }

  void setCropImage(bool value) {
    state = state.copyWith(cropImage: value);
    _preferences.setBool('cropImage', value);
  }

  void setAutoplayGifs(int value) {
    state = state.copyWith(autoplayGifs: value);
    // NOTE: `autoplayMedia` is used for gifs
    _preferences.setInt('autoplayMedia', value);
  }

  void setAutoplayVideos(int value) {
    state = state.copyWith(autoplayVideos: value);
    _preferences.setInt('autoplayVideos', value);
  }

  void setStartVideoPlaybackMuted(bool value) {
    state = state.copyWith(startVideoPlaybackMuted: value);
    _preferences.setBool('startVideoPlaybackMuted', value);
  }

  void setHidePossiblySensitive(bool value) {
    state = state.copyWith(hidePossiblySensitive: value);
    _preferences.setBool('hidePossiblySensitive', value);
  }

  void setOpenLinksExternally(bool value) {
    state = state.copyWith(openLinksExternally: value);
    _preferences.setBool('openLinksExternally', value);
  }

  void setShowDownloadDialog(bool value) {
    state = state.copyWith(showDownloadDialog: value);
    _preferences.setBool('showDownloadDialog', value);
  }

  void setDownloadPathData(String value) {
    state = state.copyWith(downloadPathData: value);
    _preferences.setString('downloadPathData', value);
  }
}

@freezed
class MediaPreferences with _$MediaPreferences {
  factory MediaPreferences({
    /// Whether the best media quality should be used.
    ///
    /// Right now this only affects the image quality because the second best
    /// video / gif quality is way worse than the best video quality.
    ///
    /// 0: always use best quality
    /// 1: only use best quality when using wifi
    /// 2: never use best quality
    required int bestMediaQuality,

    /// Whether the image height of a tweet with a single image should be
    /// constrained to a 16 / 9 aspect ratio.
    required bool cropImage,

    /// Whether gifs should play automatically.
    ///
    /// 0: always autoplay
    /// 1: only autoplay when using wifi
    /// 2: never autoplay
    required int autoplayGifs,

    /// Whether videos should play automatically.
    ///
    /// 0: always autoplay
    /// 1: only autoplay when using wifi
    /// 2: never autoplay
    required int autoplayVideos,

    /// Whether video playback should start with volume 0 by default.
    required bool startVideoPlaybackMuted,

    /// Whether possibly sensitive (NSFW) media should be hidden by default.
    required bool hidePossiblySensitive,

    /// Whether links should open externally instead of using a built in web
    /// view.
    // NOTE: not currently used
    required bool openLinksExternally,

    /// Whether the download dialog should show when downloading media.
    required bool showDownloadDialog,

    /// Encoded download path data that maps a media type with its download
    /// path.
    required String downloadPathData,
  }) = _MediaPreferences;

  MediaPreferences._();

  /// Whether gifs should play automatically, taking the connectivity into
  /// account.
  bool shouldAutoplayGifs(ConnectivityResult connectivity) =>
      autoplayGifs == 0 ||
      autoplayGifs == 1 && connectivity == ConnectivityResult.wifi;

  /// Whether videos should play automatically, taking the connectivity into
  /// account.
  bool shouldAutoplayVideos(ConnectivityResult connectivity) =>
      autoplayVideos == 0 ||
      autoplayVideos == 1 && connectivity == ConnectivityResult.wifi;

  /// Whether the best media quality should be used, taking the connectivity
  /// into account.
  bool shouldUseBestMediaQuality(ConnectivityResult connectivity) =>
      bestMediaQuality == 0 ||
      bestMediaQuality == 1 && connectivity == ConnectivityResult.wifi;
}
