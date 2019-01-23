import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/models/tweet_model.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

class MediaModel extends Model {
  MediaModel({
    @required this.tweetModel,
  }) : assert(tweetModel != null);

  final TweetModel tweetModel;

  /// Returns the list of [TwitterMedia] for this tweet.
  ///
  /// Returns `null` if the [TweetModel.tweet] has no media attached.
  List<TwitterMedia> get media => tweetModel.tweet?.extended_entities?.media;

  /// Returns a unique [String] for the [TwitterMedia] in that [Tweet].
  String mediaHeroTag(int index) {
    return "$index-${media[index].idStr}-${tweetModel.originalTweet.idStr}";
  }

  void saveShowMediaState(bool showing) {
    // todo
//    if (type == ListType.home) {
//      showing
//          ? HomeStore.showTweetMediaAction(widget.tweet)
//          : HomeStore.hideTweetMediaAction(widget.tweet);
//    } else if (type == ListType.user) {
//      showing
//          ? HomeStore.showTweetMediaAction(widget.tweet)
//          : HomeStore.hideTweetMediaAction(widget.tweet);
//    }
  }

  static MediaModel of(BuildContext context) {
    return ScopedModel.of<MediaModel>(context);
  }
}
