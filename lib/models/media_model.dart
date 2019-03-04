import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/api/twitter/data/video_info.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/settings/media_settings_model.dart';
import 'package:harpy/models/tweet_model.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

class MediaModel extends Model {
  MediaModel({
    @required this.tweetModel,
    @required this.homeTimelineModel,
    @required this.mediaSettingsModel,
  })  : assert(tweetModel != null),
        assert(homeTimelineModel != null),
        assert(mediaSettingsModel != null);

  final TweetModel tweetModel;
  final HomeTimelineModel homeTimelineModel;
  final MediaSettingsModel mediaSettingsModel;

  static final Logger _log = Logger("MediaModel");

  static MediaModel of(BuildContext context) {
    return ScopedModel.of<MediaModel>(context);
  }

  /// Returns the list of [TwitterMedia] for the tweet.
  List<TwitterMedia> get media => tweetModel.tweet.extended_entities.media;

  /// Returns the video url of the video or `null` if no videoInfo exists for
  /// the [media].
  ///
  /// Takes the selected media quality into account.
  String getVideoUrl() {
    List<Variants> variants = media.first?.videoInfo?.variants;

    if (variants?.isEmpty ?? true) {
      return null;
    }

    // remove the x-mpeg video without a bitrate
    variants.removeWhere((variants) => variants.bitrate == null);

    // sort by bitrate (large, medium, small)
    variants.sort((v1, v2) {
      return v2.bitrate - v1.bitrate;
    });

    // todo: check if wifi connection exists
    int index = mediaSettingsModel.wifiMediaQuality;

    if (variants.length > index) {
      return variants[index].url;
    } else {
      return variants.first.url;
    }
  }

  /// Returns the [TwitterMedia.mediaUrl] for the first media in the list.
  ///
  /// For videos and gifs this is the url for the thumbnail.
  String getThumbnailUrl() {
    return media.first?.mediaUrl;
  }

  /// Returns the aspect ratio of the video or `1` if no videoInfo exists for
  /// the [media].
  double getVideoAspectRatio() {
    return (media.first?.videoInfo?.aspectRatio[0] ?? 1) /
        (media.first?.videoInfo?.aspectRatio[1] ?? 1);
  }

  /// Whether or not the media should show when building.
  bool get initiallyShown =>
      tweetModel.tweet.harpyData.showMedia ??
      mediaSettingsModel.defaultHideMedia != 2;

  /// Returns a unique [String] for the [TwitterMedia] in that [Tweet].
  String mediaHeroTag(int index) {
    return "$index-${media[index].idStr}-${tweetModel.originalTweet.idStr}";
  }

  void saveShowMediaState(bool showing) {
    _log.fine("saving show media state: $showing");
    Tweet tweet = tweetModel.tweet;
    tweet.harpyData.showMedia = showing;

    // update in home timeline
    homeTimelineModel.updateTweet(tweet);

    // update in cache
    tweetModel.homeTimelineCache.updateTweet(tweet);
    tweetModel.userTimelineCache?.updateTweet(tweet);
  }
}
