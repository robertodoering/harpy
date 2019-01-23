import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/tweet_model.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

class MediaModel extends Model {
  MediaModel({
    @required this.tweetModel,
    @required this.homeTimelineModel,
  })  : assert(tweetModel != null),
        assert(homeTimelineModel != null);

  final TweetModel tweetModel;
  final HomeTimelineModel homeTimelineModel;

  static final Logger _log = Logger("MediaModel");

  static MediaModel of(BuildContext context) {
    return ScopedModel.of<MediaModel>(context);
  }

  /// Returns the list of [TwitterMedia] for this tweet.
  ///
  /// Returns `null` if the [TweetModel.tweet] has no media attached.
  List<TwitterMedia> get media => tweetModel.tweet?.extended_entities?.media;

  /// Whether or not the media should show or not when building.
  bool get initiallyShown =>
      tweetModel.tweet.harpyData.showMedia ?? true; // todo: get from settings

  /// Returns a unique [String] for the [TwitterMedia] in that [Tweet].
  String mediaHeroTag(int index) {
    return "$index-${media[index].idStr}-${tweetModel.originalTweet.idStr}";
  }

  void saveShowMediaState(bool showing) {
    _log.fine("saving show media state: $showing");
    Tweet tweet = tweetModel.tweet;
    tweet.harpyData.showMedia = showing;

    homeTimelineModel.updateTweet(tweet);

    tweetModel.tweetCache.updateTweet(tweet);
  }
}
