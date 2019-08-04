import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/error_handler.dart';
import 'package:harpy/api/twitter/services/tweet_search_service.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/harpy.dart';

/// The model for replies to a specific [tweet].
///
/// Replies for the [tweet] are loaded upon creation and stored in [replies].
class TweetRepliesModel extends ChangeNotifier {
  TweetRepliesModel({
    @required this.tweet,
  }) {
    _loadReplies();
  }

  final Tweet tweet;

  final TweetService tweetService = app<TweetService>();
  final TweetSearchService tweetSearchService = app<TweetSearchService>();

  /// The parent tweet if the [tweet] itself is a reply.
  ///
  /// `null` if [tweet] is not a reply.
  Tweet _parentTweet;
  Tweet get parentTweet => _parentTweet;

  /// The replies for the [tweet].
  List<Tweet> _replies = [];
  List<Tweet> get replies => UnmodifiableListView(_replies);

  /// True while loading the replies.
  bool _loading = false;
  bool get loading => _loading;

  /// Returns `true` if no replies for the [tweet] could be found.
  bool get noRepliesFound => _replies.isEmpty && !loading;

  Future<void> _loadReplies() async {
    _loading = true;
    notifyListeners();

    // load parent tweet if available
    if (tweet.inReplyToStatusIdStr?.isNotEmpty == true) {
      final Tweet parent = await tweetService
          .getTweet(tweet.inReplyToStatusIdStr)
          .catchError(twitterClientErrorHandler);

      if (parent != null) {
        _parentTweet = parent;
      }
    }

    final List<Tweet> loadedReplies = await tweetSearchService
        .getReplies(tweet)
        .catchError(twitterClientErrorHandler);

    if (loadedReplies != null) {
      _replies = loadedReplies
        ..forEach((reply) => reply.harpyData.childOfReply = true);
    }

    _loading = false;
    notifyListeners();
  }
}
