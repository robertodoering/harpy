import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

class TweetModel extends Model {
  TweetModel({
    @required this.originalTweet,
    @required this.tweetCache,
  }) : assert(tweetCache != null);

  final Tweet originalTweet;
  final TweetCache tweetCache;

  /// Returns the [Tweet.retweetedStatus] if the [originalTweet] is a retweet
  /// else the [originalTweet].
  Tweet get tweet => originalTweet.retweetedStatus ?? originalTweet;

  /// Whether or not the [originalTweet] is a retweet.
  bool get isRetweet => originalTweet.retweetedStatus != null;

  /// Whether or not the [tweet] contains [TweetMedia].
  bool get hasMedia => tweet.extended_entities?.media != null;

  /// A formatted number of the retweet count.
  String get retweetCount => "${formatNumber(tweet.retweetCount)}";

  /// A formatted number of the favorite count.
  String get favoriteCount => "${formatNumber(tweet.favoriteCount)}";

  static TweetModel of(BuildContext context) {
    return ScopedModel.of<TweetModel>(context);
  }
}
