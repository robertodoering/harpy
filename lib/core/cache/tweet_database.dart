import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/cache/database.dart';
import 'package:logging/logging.dart';
import 'package:sembast/sembast.dart';

/// Stores [Tweet] objects as a json object in a database.
class TweetDatabase extends HarpyDatabase {
  TweetDatabase({
    StoreRef<int, Map<String, dynamic>> store,
  }) : store = store ?? intMapStoreFactory.store();

  final StoreRef<int, Map<String, dynamic>> store;

  @override
  String get name => "tweet_db/$subDirectory";

  final Logger _log = Logger("TweetDatabase");

  /// Records or the [tweet] in the tweet database.
  ///
  /// Overrides any existing [Tweet] with the same [Tweet.id].
  Future<bool> recordTweet(Tweet tweet) async {
    _log.fine("recording tweet with id ${tweet.id}");

    try {
      await store.record(tweet.id).put(db, tweet.toJson());
      _log.fine("tweet recorded");
      return true;
    } catch (e, st) {
      _log.severe("error while trying to record tweet", e, st);
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

    final records = await store.find(
      db,
      finder: Finder(
        filter: Filter.inList("id", ids),
        sortOrders: [SortOrder("id", false, true)],
      ),
    );

    final tweets =
        records.map((record) => Tweet.fromJson(record.value)).toList();

    _log.fine("found ${tweets.length} tweets");

    return tweets;
  }

  /// Returns whether or not a tweet with the [id] exists in the tweet database.
  Future<bool> tweetExists(int id) async {
    _log.fine("checking if tweet with id $id exists");

    final record = await store.findFirst(
      db,
      finder: Finder(filter: Filter.byKey(id)),
    );

    return record != null;
  }
}
