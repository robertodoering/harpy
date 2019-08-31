import 'package:flutter/foundation.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/cache/database_base.dart';
import 'package:harpy/core/utils/json_utils.dart';
import 'package:logging/logging.dart';
import 'package:sembast/sembast.dart';

/// Stores [Tweet] objects in a database.
///
/// Tweets are stored uniquely for each authorized user because they can
/// contain user specific data ([Tweet.favorited], [Tweet.retweeted],
/// [Tweet.harpyData], ...).
class TweetDatabase extends HarpyDatabase {
  final StoreRef<int, Map<String, dynamic>> store = intMapStoreFactory.store();

  @override
  String get name => "tweet_db";

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

      await databaseService.record(
        path: path,
        store: store,
        key: tweet.id,
        data: tweetJson,
      );

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

      await databaseService.transaction(
        path: path,
        store: store,
        keys: tweets.map((tweet) => tweet.id).toList(),
        dataList: tweetJsonList,
      );

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
      final finder = Finder(
        filter: Filter.inList("id", ids),
        sortOrders: [SortOrder("id", false, true)],
      );

      final List values = await databaseService.find(
        path: path,
        store: store,
        finder: finder,
      );

      final tweets = await compute<List, List<Tweet>>(
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

  /// Limits the amount of recorded tweets to [targetAmount] if the [limit]
  /// has been reached.
  ///
  /// The [targetAmount] must be less than [limit] and ensures that a buffer
  /// exists before recorded tweets gets limited again.
  ///
  /// Only the newest tweets will remain.
  /// Has no effect if [limit] is greater than the amount of recorded tweets.
  Future<bool> limitRecordedTweets({
    @required int limit,
    @required int targetAmount,
  }) async {
    _log.fine("limiting recorded tweets to $targetAmount on limit $limit");

    assert(targetAmount < limit);

    try {
      final finder = Finder(
        sortOrders: [SortOrder("id", false, true)],
      );

      List values = await databaseService.find(
        path: path,
        store: store,
        finder: finder,
      );

      _log.info("found ${values.length} stored tweets");

      if (values.length < limit) {
        _log.fine("stored tweets <= limit");
        return false;
      }

      values = values.sublist(0, targetAmount);

      _log.fine("deleting database content");

      await databaseService.drop(name: name);

      _log.fine("recording ${values.length} limited tweets");

      await databaseService.transaction(
        path: path,
        store: store,
        keys: values.map((value) => value["id"]).toList(),
        dataList: values,
      );

      _log.fine("recorded tweets limited");
      return true;
    } catch (e, st) {
      _log.severe("exception while limiting tweets", e, st);
      return false;
    }
  }

  /// Returns whether or not a tweet with the [id] exists in the tweet database.
  Future<bool> tweetExists(int id) async {
    _log.fine("checking if tweet with id $id exists");

    return findTweets([id]).then((tweets) => tweets.isNotEmpty);
  }
}

List<Map<String, dynamic>> _handleTweetListSerialization(List<Tweet> tweets) {
  return tweets.map((tweet) => toPrimitiveJson(tweet.toJson())).toList();
}

Map<String, dynamic> _handleTweetSerialization(Tweet tweet) {
  return toPrimitiveJson(tweet.toJson());
}

List<Tweet> _handleTweetListDeserialization(
  List tweetsJson,
) {
  return tweetsJson.map((tweetJson) => Tweet.fromJson(tweetJson)).toList();
}
