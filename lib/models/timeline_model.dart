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
  List<Tweet> tweets = [];

  /// A sublist of [tweets] with the currently visible [Tweet]s.
  List<Tweet> visibleTweets = [];

  /// `true` while loading [tweets].
  bool loadingInitialTweets = false;

  /// `true` while requesting more tweets from the timeline (when scrolling to
  /// the bottom of the tweet list).
  bool requestingMore = false;

  /// Returns `true` if [lastRequestedMore] has been set to less than 90
  /// seconds from [DateTime.now].
  bool get blockRequestingMore {
    if (lastRequestedMore == null) {
      return false;
    }
    return DateTime.now().difference(lastRequestedMore).inSeconds < 90;
  }

  /// The last time [requestingMore] was called.
  DateTime lastRequestedMore;

  Future<void> initTweets() async {
    _log.fine("initializing tweets");
    loadingInitialTweets = true;

    // initialize with cached tweets
    final List<Tweet> cachedTweets = await getCachedTweets() ?? [];

    if (cachedTweets.isEmpty) {
      // if no cached tweet exists wait for the initial api call
      _log.fine("no cached tweets exist");
      await updateTweets();
    } else {
      // if cached tweets exist update tweets but dont wait for it
      _log.fine("got cached tweets");
      tweets = sortTweetReplies(cachedTweets);
      loadingInitialTweets = false;
      updateTweets();
    }
  }

  /// Overridden by implementations to get the cached tweets for the timeline.
  Future<List<Tweet>> getCachedTweets();

  /// Overridden by implementations to update the list of [tweets].
  Future<void> updateTweets();

  Future<void> requestMore() async {
    _log.fine("requesting more");

    if (tweets.isEmpty) {
      _log.warning("tweets empty, not requesting more");
      return;
    } else if (requestingMore) {
      _log.warning("tried to request more while already requesting");
      return;
    } else if (blockRequestingMore) {
      _log.warning("tried to request more while its still blocked");
      notifyListeners();
      return;
    }

    requestingMore = true;
    notifyListeners();

    lastRequestedMore = DateTime.now();
  }

  /// Adds all [newTweets] to the list of [tweets] if they aren't already in
  /// the list.
  void addNewTweets(List<Tweet> newTweets) {
    // filter tweets that are already in the tweets list
    final List<Tweet> filteredTweets =
        newTweets.where((tweet) => !tweets.contains(tweet)).toList();

    tweets.addAll(sortTweetReplies(filteredTweets));
  }
}
