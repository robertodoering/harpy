import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/api/twitter/data/video_info.dart';
import 'package:harpy/components/widgets/media/tweet_media.dart';
import 'package:harpy/core/cache/tweet_database.dart';
import 'package:harpy/core/misc/connectivity_service.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/settings/media_settings_model.dart';
import 'package:harpy/models/tweet_model.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class MediaModel extends ChangeNotifier {
  MediaModel({
    @required this.tweetModel,
    @required this.homeTimelineModel,
    @required this.mediaSettingsModel,
  })  : assert(tweetModel != null),
        assert(homeTimelineModel != null),
        assert(mediaSettingsModel != null) {
    // use wifi media quality when connected to a wifi, else the non wifi media
    // quality
    mediaQuality = connectivityService.wifi
        ? mediaSettingsModel.wifiMediaQuality
        : mediaSettingsModel.nonWifiMediaQuality;
  }

  final ConnectivityService connectivityService = app<ConnectivityService>();
  final TweetDatabase tweetDatabase = app<TweetDatabase>();

  final TweetModel tweetModel;
  final HomeTimelineModel homeTimelineModel;
  final MediaSettingsModel mediaSettingsModel;

  static MediaModel of(BuildContext context) {
    return Provider.of<MediaModel>(context);
  }

  static final Logger _log = Logger("MediaModel");

  /// The selected quality for the media.
  ///
  /// Initially loaded from settings.
  ///
  /// 0: large
  /// 1: medium
  /// 2: small
  int mediaQuality;

  /// Returns the list of [TwitterMedia] for the tweet.
  List<TwitterMedia> get media => tweetModel.tweet.extendedEntities.media;

  /// Returns the video url of the video or `null` if no videoInfo exists for
  /// the [media].
  ///
  /// Takes the selected media quality into account.
  String get videoUrl {
    final List<Variants> variants = media.first?.videoInfo?.variants;

    if (variants?.isEmpty ?? true) {
      return null;
    }

    // remove the x-mpeg video without a bitrate
    variants
      ..removeWhere((variants) => variants.bitrate == null)
      // sort by bitrate (large, medium, small)
      ..sort((v1, v2) {
        return v2.bitrate - v1.bitrate;
      });

    final int index = mediaQuality;

    if (variants.length > index) {
      return variants[index].url;
    } else {
      return variants.first.url;
    }
  }

  /// Returns the [TwitterMedia.mediaUrl] for the first media in the list.
  ///
  /// For videos and gifs this is the url for the thumbnail.
  String get thumbnailUrl {
    return media.first?.mediaUrl;
  }

  /// Returns the aspect ratio of the video or `1` if no videoInfo exists for
  /// the [media].
  double get videoAspectRatio {
    return (media.first?.videoInfo?.aspectRatio[0] ?? 1) /
        (media.first?.videoInfo?.aspectRatio[1] ?? 1);
  }

  /// Whether or not the media should show when building.
  bool get initiallyShown {
    // when the media has manually been hidden or shown
    if (tweetModel.tweet.harpyData.showMedia != null) {
      return tweetModel.tweet.harpyData.showMedia;
    }

    // from settings
    final int defaultHideMedia = mediaSettingsModel.defaultHideMedia;

    if (defaultHideMedia == 0) return true; // show
    if (defaultHideMedia == 1) return connectivityService.wifi; // only if wifi
    return false; // don't initially show
  }

  /// Whether or not the gif should start playing automatically.
  bool get autoplay {
    if (!media.any((media) => media.type == animatedGif)) {
      // only autoplay gifs
      return false;
    }

    final int autoplayMedia = mediaSettingsModel.autoplayMedia;

    if (autoplayMedia == 0) return true; // autoplay
    if (autoplayMedia == 1) return connectivityService.wifi; // only if wifi
    return false; // don't autoplay
  }

  /// Returns a unique [String] for the [TwitterMedia] in that [Tweet].
  String mediaHeroTag(int index) {
    return "$index-${media[index].idStr}-${tweetModel.originalTweet.idStr}";
  }

  void saveShowMediaState(bool showing) {
    _log.fine("saving show media state: $showing");
    final Tweet tweet = tweetModel.tweet;
    tweet.harpyData.showMedia = showing;

    // update in home timeline
    homeTimelineModel.updateTweet(tweet);

    // update in cache
    tweetDatabase.recordTweet(tweet);
  }
}
