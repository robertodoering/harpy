import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/service_utils.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/cache/timeline_database.dart';
import 'package:harpy/core/cache/tweet_database.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/user_timeline_model.dart';
import 'package:logging/logging.dart';

/// Abstraction for the [HomeTimelineModel] and the [UserTimelineModel].
///
/// Holds the [tweets] of the timeline and common actions for the
/// [tweetService].
abstract class TimelineModel extends ChangeNotifier {
  final TweetService tweetService = app<TweetService>();
  final TweetDatabase tweetDatabase = app<TweetDatabase>();
  final TimelineDatabase timelineDatabase = app<TimelineDatabase>();

  static final Logger _log = Logger("TimelineModel");

  /// The [tweets] for this timeline.
  List<Tweet> get tweets => UnmodifiableListView(_tweets);
  List<Tweet> _tweets = [];
  @protected
  set tweets(List<Tweet> tweets) => _tweets = tweets;

  /// `true` while loading [tweets].
  bool loadingInitialTweets = false;

  /// Whether or not more tweets should be able to be requested when
  /// reaching the end of the list.
  bool get enableRequestingMore => _tweets.isNotEmpty && !_blockRequestingMore;

  /// Called when tweets are updated in the [HomeTimelineModel].
  VoidCallback onTweetsUpdated;

  /// Returns `true` if [lastRequestedMore] has been set to less than 90
  /// seconds from [DateTime.now].
  bool get _blockRequestingMore => lastRequestedMore == null
      ? false
      : DateTime.now().difference(lastRequestedMore).inSeconds < 90;

  /// The last time [requestMore] was called.
  DateTime lastRequestedMore;

  /// Initializes the [tweets] with cached tweets and updates the [tweets]
  /// afterwards.
  Future<void> initTweets() async {
    _log.fine("initializing tweets");
    loadingInitialTweets = true;
    notifyListeners();

    await updateTweets(timeout: const Duration(seconds: 5), silentError: true);

    if (_tweets.isEmpty) {
      _log.fine("unable to initialize tweets, getting cached tweets");
      final List<Tweet> cachedTweets = await getCachedTweets() ?? [];

      if (cachedTweets.isNotEmpty) {
        _tweets = sortTweetReplies(cachedTweets);
      }
    }

    loadingInitialTweets = false;
    notifyListeners();
  }

  /// Gets a list of cached [Tweet]s for the timeline or an empty list if no
  /// cached tweets exists for the timeline.
  Future<List<Tweet>> getCachedTweets();

  /// Updates the [tweets] to the newest tweets for the timeline.
  ///
  /// If [silentError] is `true`, any exception during the request (for
  /// example a timeout) won't be shown.
  /// This is used when initially loading the [_tweets] with a low [timeout].
  Future<void> updateTweets({Duration timeout, bool silentError});

  /// Returns new tweets for the timeline.
  ///
  /// They are the tweets that come after the current [tweets].
  /// [tweets] must not be empty when calling this.
  Future<List<Tweet>> requestMoreTweets();

  /// Used to request more [Tweet]s for the timeline when reaching the end of
  /// the list.
  Future<void> requestMore() async {
    _log.fine("requesting more");

    final List<Tweet> newTweets = await requestMoreTweets();

    if (newTweets != null) {
      _addNewTweets(newTweets);
    }

    lastRequestedMore = DateTime.now();
    notifyListeners();
  }

  /// Adds all [newTweets] to the list of [tweets] if they aren't already in
  /// the list.
  void _addNewTweets(List<Tweet> newTweets) {
    // filter tweets that are already in the tweets list
    final List<Tweet> filteredTweets =
        newTweets.where((tweet) => !_tweets.contains(tweet)).toList();

    _tweets.addAll(sortTweetReplies(filteredTweets));
  }

  /// Finds the authors for the [tweet] replies by looking through the
  /// replies in [tweets] and returning their names in a formatted string.
  ///
  /// If no replies are found or if the only replies are from the parent
  /// author, `null` is returned instead.
  // todo: maybe do this once in an isolate when retrieving the tweets and
  //  save the reply authors in the harpyData for the parent tweets
  String findTweetReplyAuthors(Tweet tweet) {
    if (tweet.harpyData.parentOfReply != true) {
      return null;
    }

    final List<Tweet> replies = _tweets
        .where((child) => child.inReplyToStatusIdStr == tweet.idStr)
        .toList();

    if (replies.isEmpty ||
        replies.where((reply) => reply.user.id != tweet.user.id).isEmpty) {
      return null;
    }

    final String authors = replies.map((reply) => reply.user.name).join(", ");

    return "$authors replied";
  }
}
