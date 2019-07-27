import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/cache/new/database.dart';
import 'package:harpy/core/cache/new/tweet_database.dart';
import 'package:harpy/harpy.dart';
import 'package:logging/logging.dart';
import 'package:sembast/sembast.dart';

/// Stores the ids for home and user timeline tweets in a database.
class TimelineDatabase extends HarpyDatabase {
  TimelineDatabase({
    StoreRef<String, List<int>> homeTimelineStore,
    StoreRef<int, List<int>> userTimelineStore,
  })  : homeTimelineStore =
            homeTimelineStore ?? StoreRef<String, List<int>>("home_timeline"),
        userTimelineStore =
            userTimelineStore ?? StoreRef<int, List<int>>("user_timeline");

  final StoreRef<String, List<int>> homeTimelineStore;
  final StoreRef<int, List<int>> userTimelineStore;

  final TweetDatabase tweetDatabase = app<TweetDatabase>();

  @override
  String get name => "timeline_db";

  final Logger _log = Logger("TimelineDatabase");

  /// Records the ids of the [tweets].
  ///
  /// Exactly one list of ids exists for the home timeline.
  Future<bool> recordHomeTimelineIds(List<Tweet> tweets) async {
    _log.fine("recording home timeline ids");

    try {
      final ids = tweets.map((tweet) => tweet.id).toList();

      await homeTimelineStore.record("ids").put(db, ids);

      _log.fine("recorded ${ids.length} home timeline ids");
      return true;
    } catch (e, st) {
      _log.severe("exception while recording home timeline ids", e, st);
      return false;
    }
  }

  /// Records the ids of the [tweets] for the [user].
  ///
  /// Every unique [User.id] will have a list with the tweet ids.
  Future<bool> recordUserTimelineIds(User user, List<Tweet> tweets) async {
    _log.fine("recording user timeline ids for ${user.screenName}");

    try {
      final ids = tweets.map((tweet) => tweet.id).toList();

      await userTimelineStore.record(user.id).put(db, ids);

      _log.fine("recorded ${ids.length} user timeline ids");
      return true;
    } catch (e, st) {
      _log.severe("exception while recording user timeline ids", e, st);
      return false;
    }
  }

  /// Returns the home timeline tweets by retrieving the cached home timeline
  /// ids and finding the corresponding tweets in the [TweetDatabase].
  Future<List<Tweet>> findHomeTimelineTweets() async {
    _log.fine("finding home timeline tweets");

    final record = await homeTimelineStore.findFirst(
      db,
      finder: Finder(filter: Filter.byKey("ids")),
    );

    final ids = record?.value ?? <int>[];

    _log.fine("found ${ids.length} home timeline ids");

    if (ids.isNotEmpty) {
      return tweetDatabase.findTweets(ids);
    } else {
      return [];
    }
  }

  /// Returns the timeline tweets for the [user] by retrieving the cached
  /// user timeline ids and finding the corresponding tweets in the
  /// [TweetDatabase].
  Future<List<Tweet>> findUserTimelineTweets(User user) async {
    _log.fine("finding user timeline tweets");

    final record = await userTimelineStore.findFirst(
      db,
      finder: Finder(filter: Filter.byKey(user.id)),
    );

    final ids = record?.value ?? <int>[];

    _log.fine("found ${ids.length} user timeline ids");

    if (ids.isNotEmpty) {
      return tweetDatabase.findTweets(ids);
    } else {
      return [];
    }
  }
}
