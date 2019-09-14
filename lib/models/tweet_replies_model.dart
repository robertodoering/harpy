import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/error_handler.dart';
import 'package:harpy/api/twitter/services/tweet_search_service.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/harpy.dart';
import 'package:logging/logging.dart';

/// The model for replies to a specific [tweet].
///
/// Replies for the [tweet] are loaded upon creation and stored in [replies].
class TweetRepliesModel extends ChangeNotifier {
  TweetRepliesModel({
    @required this.tweet,
  }) {
    _initReplies();
  }

  final Tweet tweet;

  final TweetService tweetService = app<TweetService>();
  final TweetSearchService tweetSearchService = app<TweetSearchService>();

  static final Logger _log = Logger("TweetRepliesModel");

  /// The parent tweet if the [tweet] itself is a reply.
  ///
  /// `null` if [tweet] is not a reply.
  Tweet _parentTweet;
  Tweet get parentTweet => _parentTweet;

  /// The replies for the [tweet].
  final List<Tweet> _replies = [];
  List<Tweet> get replies => UnmodifiableListView(_replies);

  /// True while loading the replies.
  bool _loading = true;
  bool get loading => _loading;

  /// The last [TweetRepliesResult] used for requesting more replies.
  TweetRepliesResult _lastResult;

  /// Whether or not all replies have been received.
  bool _lastPage = false;
  bool get lastPage => _lastPage;

  /// Loads the parent tweet and the initial list of replies.
  Future<void> _initReplies() async {
    await Future.wait([
      _loadParentTweet(),
      _loadReplies(),
    ]);

    _loading = false;
    notifyListeners();
  }

  /// Loads the parent tweet if the [tweet] itself is a reply.
  Future<void> _loadParentTweet() async {
    if (tweet.inReplyToStatusIdStr?.isNotEmpty == true) {
      final Tweet parent = await tweetService
          .getTweet(tweet.inReplyToStatusIdStr)
          .catchError(twitterClientErrorHandler);

      if (parent != null) {
        _parentTweet = parent;
      }
    }
  }

  Future<void> _loadReplies() async {
    final TweetRepliesResult result = await tweetSearchService
        .getReplies(
          tweet,
          lastResult: _lastResult,
        )
        .catchError(twitterClientErrorHandler);

    if (result != null) {
      _lastResult = result;

      // filter duplicates (just in case) and set child flag to true
      final newReplies = result.replies.where(
        (reply) => !_replies.contains(reply),
      )..forEach((reply) => reply.harpyData.childOfReply = true);

      _log.fine("found ${newReplies.length} replies");

      _replies.addAll(newReplies);
    }

    _lastPage = result?.lastPage ?? true;

    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_lastPage) {
      _log.warning("tried to load more replies while already all replies have"
          " been loaded.");
      return;
    }

    await _loadReplies();
  }
}
