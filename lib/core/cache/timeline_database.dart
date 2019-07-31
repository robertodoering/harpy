import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/cache/database.dart';
import 'package:harpy/core/cache/tweet_database.dart';
import 'package:harpy/harpy.dart';
import 'package:logging/logging.dart';
import 'package:sembast/sembast.dart';

/// Stores the ids for home and user timeline tweets in a database.
class TimelineDatabase extends HarpyDatabase {
  TimelineDatabase({
    StoreRef<String, List> homeTimelineStore,
    StoreRef<int, List> userTimelineStore,
  })  : homeTimelineStore =
            homeTimelineStore ?? StoreRef<String, List>("home_timeline"),
        userTimelineStore =
            userTimelineStore ?? StoreRef<int, List>("user_timeline");

  final StoreRef<String, List> homeTimelineStore;
  final StoreRef<int, List> userTimelineStore;

  final TweetDatabase tweetDatabase = app<TweetDatabase>();

  @override
  String get name => "timeline_db/$subDirectory";

  static final Logger _log = Logger("TimelineDatabase");

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
  Future<bool> recordUserTimelineIds(int userId, List<Tweet> tweets) async {
    _log.fine("recording user timeline ids for $userId");

    try {
      final ids = tweets.map((tweet) => tweet.id).toList();

      await userTimelineStore.record(userId).put(db, ids);

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

    List<int> ids;

    try {
      final RecordSnapshot<String, List> record =
          await homeTimelineStore.findFirst(
        db,
        finder: Finder(filter: Filter.byKey("ids")),
      );

      ids = record?.value?.cast<int>() ?? <int>[];

      _log.fine("found ${ids.length} home timeline ids");
    } catch (e, st) {
      _log.severe("exception while finding home timeline ids", e, st);
      return <Tweet>[];
    }

    if (ids.isNotEmpty) {
      return tweetDatabase.findTweets(ids);
    } else {
      return <Tweet>[];
    }
  }

  /// Returns the timeline tweets for the [userId] by retrieving the cached
  /// user timeline ids and finding the corresponding tweets in the
  /// [TweetDatabase].
  Future<List<Tweet>> findUserTimelineTweets(int userId) async {
    _log.fine("finding user timeline tweets");

    List<int> ids;

    try {
      final record = await userTimelineStore.findFirst(
        db,
        finder: Finder(filter: Filter.byKey(userId)),
      );

      ids = record?.value?.cast<int>() ?? <int>[];

      _log.fine("found ${ids.length} user timeline ids");
    } catch (e, st) {
      _log.severe("exception while finding user timeline ids", e, st);
      return <Tweet>[];
    }

    if (ids.isNotEmpty) {
      return tweetDatabase.findTweets(ids);
    } else {
      return [];
    }
  }
}
