import 'package:flutter/foundation.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/cache/database.dart';
import 'package:harpy/core/utils/json_utils.dart';
import 'package:logging/logging.dart';
import 'package:sembast/sembast.dart';

/// Stores [Tweet] objects in a database.
class TweetDatabase extends HarpyDatabase {
  TweetDatabase({
    StoreRef<int, Map<String, dynamic>> store,
  }) : store = store ?? intMapStoreFactory.store();

  final StoreRef<int, Map<String, dynamic>> store;

  @override
  String get name => "tweet_db/$subDirectory";

  static final Logger _log = Logger("TweetDatabase");

  /// Records the [tweet] in the tweet database.
  ///
  /// Overrides any existing [Tweet] with the same [Tweet.id].
  Future<bool> recordTweet(Tweet tweet) async {
    _log.fine("recording tweet with id ${tweet.id}");

    try {
      final Map<String, dynamic> tweetJson =
          await compute<Tweet, Map<String, dynamic>>(
        _handleTweetSerialization,
        tweet,
      );

      await store.record(tweet.id).put(db, tweetJson);

      _log.fine("tweet recorded");
      return true;
    } catch (e, st) {
      _log.severe("error while trying to record tweet", e, st);
      return false;
    }
  }

  /// Records all [tweets] in the database in a single transaction.
  ///
  /// Any existing [Tweet] with the same [Tweet.id] will be overridden.
  Future<bool> recordTweetList(List<Tweet> tweets) async {
    _log.fine("recording ${tweets.length} tweets");

    try {
      final List<Map<String, dynamic>> tweetJsonList =
          await compute<List<Tweet>, List<Map<String, dynamic>>>(
        _handleTweetListSerialization,
        tweets,
      );

      await db.transaction((transaction) async {
        for (int i = 0; i < tweetJsonList.length; i++) {
          final Tweet tweet = tweets[i];
          final Map<String, dynamic> json = tweetJsonList[i];

          await store.record(tweet.id).put(transaction, json);
        }
      });

      _log.fine("tweets recorded");
      return true;
    } catch (e, st) {
      _log.severe("error while trying to record tweets", e, st);
      return false;
    }
  }

  /// Finds all tweets for the given [ids].
  ///
  /// The list will be sorted descending by their id.
  ///
  /// Returns an empty list if no tweets have been found.
  Future<List<Tweet>> findTweets(List<int> ids) async {
    _log.fine("finding ${ids.length} tweets");

    try {
      final records = await store.find(
        db,
        finder: Finder(
          filter: Filter.inList("id", ids),
          sortOrders: [SortOrder("id", false, true)],
        ),
      );

      final values = records.map((record) => record.value).toList();

      final tweets = await compute<List<Map<String, dynamic>>, List<Tweet>>(
        _handleTweetListDeserialization,
        values,
      );

      _log.fine("found ${tweets.length} tweets");

      return tweets;
    } catch (e, st) {
      _log.severe("exception while finding tweets", e, st);
      return <Tweet>[];
    }
  }

  /// Returns whether or not a tweet with the [id] exists in the tweet database.
  Future<bool> tweetExists(int id) async {
    _log.fine("checking if tweet with id $id exists");

    try {
      final record = await store.findFirst(
        db,
        finder: Finder(filter: Filter.byKey(id)),
      );

      return record != null;
    } catch (e, st) {
      _log.severe("exception while checking if tweet exists", e, st);
      return false;
    }
  }
}

List<Map<String, dynamic>> _handleTweetListSerialization(List<Tweet> tweets) {
  return tweets.map((tweet) => toPrimitiveJson(tweet.toJson())).toList();
}

Map<String, dynamic> _handleTweetSerialization(Tweet tweet) {
  return toPrimitiveJson(tweet.toJson());
}

List<Tweet> _handleTweetListDeserialization(
  List<Map<String, dynamic>> tweetsJson,
) {
  return tweetsJson.map((tweetJson) => Tweet.fromJson(tweetJson)).toList();
}
