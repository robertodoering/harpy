import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harpy/api/translate/data/translation.dart';
import 'package:harpy/api/translate/translate_service.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/cache/home_timeline_cache.dart';
import 'package:harpy/core/cache/user_timeline_cache.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/user_timeline_model.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

/// The [Model] for a single [Tweet].
///
/// Handles changes on the [Tweet] including actions (favorite, retweet,
/// translate, ...) and updates the [ScopedModelDescendant] when the state
/// changes.
///
/// Changes to the [Tweet] always changes the [homeTimelineCache] if the [Tweet]
/// exists in it.
/// It will also update the [Tweet] in the [userTimelineCache] if it is not
/// `null`.
class TweetModel extends Model {
  TweetModel({
    @required this.originalTweet,
    @required this.homeTimelineCache,
    @required this.userTimelineCache,
    @required this.homeTimelineModel,
    @required this.userTimelineModel,
    @required this.tweetService,
    @required this.translationService,
  })  : assert(originalTweet != null),
        assert(homeTimelineCache != null),
        assert(homeTimelineModel != null),
        assert(tweetService != null),
        assert(translationService != null);

  final Tweet originalTweet;

  final HomeTimelineCache homeTimelineCache;
  final UserTimelineCache userTimelineCache;
  final HomeTimelineModel homeTimelineModel;
  final UserTimelineModel userTimelineModel;
  final TweetService tweetService;
  final TranslationService translationService;

  static TweetModel of(BuildContext context) {
    return ScopedModel.of<TweetModel>(context);
  }

  /// Returns the [Tweet.retweetedStatus] if the [originalTweet] is a retweet
  /// else the [originalTweet].
  Tweet get tweet => originalTweet.retweetedStatus ?? originalTweet;

  /// Returns the [Tweet.quotedStatus] of the [originalTweet].
  Tweet get quote => originalTweet.quotedStatus;

  /// Whether or not the [originalTweet] is a retweet.
  bool get isRetweet => originalTweet.retweetedStatus != null;

  /// Whether or not the [originalTweet] is a reply.
  bool get isReply => originalTweet.harpyData.childOfReply == true;

  /// Whether or not the [originalTweet] is a quote.
  bool get isQuote => originalTweet.quotedStatus != null;

  /// Set to true when the [originalTweet] comes from a quoted [Tweet].
  bool quoted = false;

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
  Translation get translation => originalTweet.harpyData.translation;

  /// True while the [tweet] is being translated.
  bool translating = false;

  /// Whether or not the [tweet] has been translated.
  bool get isTranslated => translation != null;

  /// True if the [tweet] is translated and unchanged.
  bool get translationUnchanged => translation?.unchanged ?? false;

  /// Returns the names of the user that replied to this [tweet] in a formatted
  /// string.
  ///
  /// Returns an empty string if this tweet has no replies.
  String getReplyAuthors() {
    List<Tweet> tweets = (userTimelineModel ?? homeTimelineModel).tweets;

    List<Tweet> replies = tweets
        .where((child) => child.inReplyToStatusIdStr == tweet.idStr)
        .toList();

    if (replies.isEmpty) {
      return "";
    }

    if (replies.where((reply) => reply.user.id != tweet.user.id).isEmpty) {
      // if the author of the parent is the only one that replied to their tweet
      // don't show the reply authors
      return "";
    }

    String authors = replies.map((reply) => reply.user.name).join(", ");

    return "$authors replied";
  }

  void limitText({limit = 100}) {
    // todo: limit text in TwitterText and parse entities before
    // todo: bug: when limit stops in the middle of a utf16 2+ byte long emoji
    //  the app breaks because the text is not "well formatted utf16"
    //  to fix: maybe only cut off the tweet at a space
    tweet.full_text.trim();
    if (tweet.full_text.length <= limit) {
      tweet.full_text = tweet.full_text.substring(0, tweet.full_text.length);
    } else {
      tweet.full_text = tweet.full_text.substring(0, limit) + "...";
    }
    tweet.full_text = tweet.full_text.replaceAll("\n", " ");
  }

  /// Retweet this [tweet].
  void retweet() {
    tweet.retweeted = true;
    tweet.retweetCount++;
    notifyListeners();

    tweetService.retweet(tweet.idStr)
      ..then((_) {
        homeTimelineCache.updateTweet(originalTweet);
        userTimelineCache?.updateTweet(originalTweet);
      })
      ..catchError((error) {
        if (!_actionPerformed(error)) {
          tweet.retweeted = false;
          tweet.retweetCount--;
          notifyListeners();
        }
      });
  }

  /// Unretweet this [tweet].
  void unretweet() {
    tweet.retweeted = false;
    tweet.retweetCount--;
    notifyListeners();

    tweetService.unretweet(tweet.idStr)
      ..then((_) {
        homeTimelineCache.updateTweet(originalTweet);
        userTimelineCache?.updateTweet(originalTweet);
      })
      ..catchError((error) {
        if (!_actionPerformed(error)) {
          tweet.retweeted = true;
          tweet.retweetCount++;
          notifyListeners();
        }
      });
  }

  /// Favorite this [tweet].
  void favorite() {
    tweet.favorited = true;
    tweet.favoriteCount++;
    notifyListeners();

    tweetService.favorite(tweet.idStr)
      ..then((_) {
        homeTimelineCache.updateTweet(originalTweet);
        userTimelineCache?.updateTweet(originalTweet);
      })
      ..catchError((error) {
        if (!_actionPerformed(error)) {
          tweet.favorited = false;
          tweet.favoriteCount--;
          notifyListeners();
        }
      });
  }

  /// Unfavorite this [tweet].
  void unfavorite() {
    tweet.favorited = false;
    tweet.favoriteCount--;
    notifyListeners();

    tweetService.unfavorite(tweet.idStr)
      ..then((_) {
        homeTimelineCache.updateTweet(originalTweet);
        userTimelineCache?.updateTweet(originalTweet);
      })
      ..catchError((error) {
        if (!_actionPerformed(error)) {
          tweet.favorited = true;
          tweet.favoriteCount++;
          notifyListeners();
        }
      });
  }

  /// Translate this [tweet].
  ///
  /// The [Translation] is always saved in the [originalTweet], even if the
  /// [Tweet] is a retweet.
  Future<void> translate() async {
    translating = true;
    notifyListeners();

    Translation translation = await translationService
        .translate(text: tweet.full_text)
        .catchError((_) {
      translating = false;
      notifyListeners();
    });

    originalTweet.harpyData.translation = translation;

    translating = false;
    notifyListeners();

    homeTimelineCache.updateTweet(originalTweet);
    userTimelineCache?.updateTweet(originalTweet);
  }

  /// Returns `true` if the error contains any of the following error codes:
  ///
  /// 139: already favorited (trying to favorite a tweet twice)
  /// 327: already retweeted
  /// 144: tweet with id not found (trying to unfavorite a tweet twice)
  bool _actionPerformed(dynamic error) {
    try {
      List errors = jsonDecode((error as Response).body)["errors"];
      return errors.any((error) =>
          error["code"] == 139 || // already favorited
          error["code"] == 327 || // already retweeted
          error["code"] == 144); // not found
    } on Exception {
      // unexpected error format
      return false;
    }
  }
}
