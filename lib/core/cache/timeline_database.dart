import 'package:flutter/cupertino.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/cache/database_base.dart';
import 'package:harpy/core/cache/tweet_database.dart';
import 'package:harpy/harpy.dart';
import 'package:logging/logging.dart';
import 'package:sembast/sembast.dart';

/// Stores the ids for home and user timeline tweets in a database.
///
/// Both timelines share one database object but store the list of ids in
/// separate stores.
/// The home timeline always has only one list of ids.
/// The user timeline has a list of ids for every user.
class TimelineDatabase extends HarpyDatabase {
  final StoreRef<String, List> homeTimelineStore =
      StoreRef<String, List>("home_timeline");
  final StoreRef<int, List> userTimelineStore =
      StoreRef<int, List>("user_timeline");

  final TweetDatabase tweetDatabase = app<TweetDatabase>();

  @override
  String get name => "timeline_db";

  static final Logger _log = Logger("TimelineDatabase");

  /// Records the ids of the [tweets].
  ///
  /// Exactly one list of ids exists for the home timeline.
  Future<bool> recordHomeTimelineIds(List<Tweet> tweets) async {
    _log.fine("recording home timeline ids");

    return _recordsTimelineIds(
      store: homeTimelineStore,
      key: "ids",
      tweets: tweets,
    );
  }

  /// Records the ids of the [tweets] for the [user].
  ///
  /// Every unique [User.id] will have a list with tweet ids.
  Future<bool> recordUserTimelineIds(int userId, List<Tweet> tweets) async {
    _log.fine("recording user timeline ids for $userId");

    return _recordsTimelineIds(
      store: userTimelineStore,
      key: userId,
      tweets: tweets,
    );
  }

  Future<bool> _recordsTimelineIds({
    @required StoreRef store,
    @required dynamic key,
    @required List<Tweet> tweets,
  }) async {
    try {
      final ids = tweets.map((tweet) => tweet.id).toList();

      await databaseService.record(
        path: path,
        store: store,
        key: key,
        data: ids,
      );

      _log.fine("recorded ${ids.length} timeline ids");
      return true;
    } catch (e, st) {
      _log.severe("exception while recording timeline ids", e, st);
      return false;
    }
  }

  /// Returns the home timeline tweets by retrieving the cached home timeline
  /// ids and finding the corresponding tweets in the [TweetDatabase].
  Future<List<Tweet>> findHomeTimelineTweets() async {
    _log.fine("finding home timeline tweets");

    return _findTimelineTweets(store: homeTimelineStore, key: "ids");
  }

  /// Returns the timeline tweets for the [userId] by retrieving the cached
  /// user timeline ids and finding the corresponding tweets in the
  /// [TweetDatabase].
  Future<List<Tweet>> findUserTimelineTweets(int userId) async {
    _log.fine("finding user timeline tweets");

    return _findTimelineTweets(store: userTimelineStore, key: userId);
  }

  Future<List<Tweet>> _findTimelineTweets({
    @required StoreRef store,
    @required dynamic key,
  }) async {
    List<int> ids;

    try {
      final value = await databaseService.findFirst(
        path: path,
        store: store,
        finder: Finder(filter: Filter.byKey(key)),
      );

      ids = value?.cast<int>() ?? <int>[];

      _log.fine("found ${ids.length} timeline ids");
    } catch (e, st) {
      _log.severe("exception while finding timeline ids", e, st);
      return <Tweet>[];
    }

    if (ids.isNotEmpty) {
      return tweetDatabase.findTweets(ids);
    } else {
      return <Tweet>[];
    }
  }
}
