import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harpy/api/translate/data/translation.dart';
import 'package:harpy/api/translate/translate_service.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/cache/tweet_database.dart';
import 'package:harpy/core/misc/flushbar_service.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:harpy/harpy.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

/// The model for a single [Tweet].
///
/// Handles changes on the [Tweet] including actions (favorite, retweet,
/// translate, ...) and rebuilds the listeners when the state changes.
class TweetModel extends ChangeNotifier {
  TweetModel({
    @required this.originalTweet,
    this.isQuote = false,
  });

  final Tweet originalTweet;

  /// Whether or not the [TweetModel] is showing a quoted [Tweet].
  final bool isQuote;

  final TweetService tweetService = app<TweetService>();
  final TranslationService translationService = app<TranslationService>();
  final FlushbarService flushbarService = app<FlushbarService>();
  final TweetDatabase tweetDatabase = app<TweetDatabase>();

  static TweetModel of(BuildContext context) {
    return Provider.of<TweetModel>(context);
  }

  /// True while the [tweet] is being translated.
  bool translating = false;

  /// The names of the user that replied to this [tweet] in a formatted string.
  ///
  /// `null` if the [tweet] does not have any replies.
  String replyAuthors;

  /// Returns the [Tweet.retweetedStatus] if the [originalTweet] is a retweet
  /// else the [originalTweet].
  Tweet get tweet => originalTweet.retweetedStatus ?? originalTweet;

  /// Returns the text of the tweet.
  ///
  /// The text is reduced when the [tweet] is a quote.
  String get text => isQuote ? reduceText(tweet.fullText) : tweet.fullText;

  /// Whether or not the [originalTweet] is a retweet.
  bool get isRetweet => originalTweet.retweetedStatus != null;

  /// Whether or not the [originalTweet] is a reply.
  bool get isReply => originalTweet.harpyData.childOfReply == true;

  /// Whether or not the [tweet] has quoted another tweet.
  bool get hasQuote => tweet.quotedStatus != null;

  /// Returns the [Tweet.quotedStatus] of the [originalTweet].
  Tweet get quote => tweet.quotedStatus;

  /// Whether or not the [tweet] contains [TweetMedia].
  bool get hasMedia => tweet.extendedEntities?.media != null;

  /// A formatted number of the retweet count.
  String get retweetCount => "${prettyPrintNumber(tweet.retweetCount)}";

  /// A formatted number of the favorite count.
  String get favoriteCount => "${prettyPrintNumber(tweet.favoriteCount)}";

  /// @username · time since tweet in hours
  String get screenNameAndTime =>
      "@${tweet.user.screenName} \u00b7 ${tweetTimeDifference(tweet.createdAt)}";

  /// Returns the [Translation] to the [tweet].
  Translation get translation => originalTweet.harpyData.translation;

  /// Whether or not the [tweet] has been translated.
  bool get isTranslated => translation != null;

  /// True if the [tweet] is translated and unchanged.
  bool get translationUnchanged => translation?.unchanged ?? false;

  /// Retweet this [tweet].
  void retweet() {
    tweet.retweeted = true;
    tweet.retweetCount++;
    notifyListeners();

    tweetService.retweet(tweet.idStr)
      ..then((_) => tweetDatabase.recordTweet(originalTweet))
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
      ..then((_) => tweetDatabase.recordTweet(originalTweet))
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
      ..then((_) => tweetDatabase.recordTweet(originalTweet))
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
      ..then((_) => tweetDatabase.recordTweet(originalTweet))
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

    final Translation translation = await translationService
        .translate(text: tweet.fullText)
        .catchError((_) {
      translating = false;
      notifyListeners();
    });

    originalTweet.harpyData.translation = translation;

    if (translationUnchanged) {
      flushbarService.info("Tweet not translated");
    }

    translating = false;
    notifyListeners();

    tweetDatabase.recordTweet(originalTweet);
  }

  /// Returns `true` if the error contains any of the following error codes:
  ///
  /// 139: already favorited (trying to favorite a tweet twice)
  /// 327: already retweeted
  /// 144: tweet with id not found (trying to unfavorite a tweet twice)
  bool _actionPerformed(dynamic error) {
    try {
      final List errors = jsonDecode((error as Response).body)["errors"];
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
