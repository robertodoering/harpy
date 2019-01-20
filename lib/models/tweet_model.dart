import 'package:flutter/material.dart';
import 'package:harpy/api/translate/data/translation.dart';
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

  static TweetModel of(BuildContext context) {
    return ScopedModel.of<TweetModel>(context);
  }

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

  /// @username · time since tweet in hours
  String get screenNameAndTime {
    return "@${tweet.user.screenName} \u00b7 ${tweetTimeDifference(tweet.createdAt)}";
  }

  /// Returns the [Translation] to the [tweet].
  Translation get translation => tweet.harpyData.translation;

  /// True while the [tweet] is being translated.
  bool translating = false;

  /// Whether or not the [tweet] has been translated.
  bool get isTranslated => translation != null;

  /// True if the [tweet] is translated and unchanged.
  bool get translationUnchanged => translation?.unchanged ?? false;

  /// Retweet this [tweet].
  void retweet() {}

  /// Unretweet this [tweet].
  void unretweet() {}

  /// Favorite this [tweet].
  void favorite() {}

  /// Unfavorite this [tweet]
  void unfavorite() {}

  /// Translate this [tweet].
  void translate() {}
}
