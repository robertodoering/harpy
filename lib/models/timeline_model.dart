import 'package:flutter/cupertino.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// Abstraction for the [HomeTimelineModel] and the [UserTimelineModel].
///
/// Holds the [tweets] of the timeline and common actions for the
/// [tweetService].
abstract class TimelineModel extends ChangeNotifier {
  TimelineModel({
    @required this.tweetService,
    @required this.tweetCache,
  }) : assert(tweetCache != null);

  final TweetService tweetService;
  final TweetCache tweetCache;

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
    tweets = tweetCache.getCachedTweets();

    if (tweets?.isEmpty ?? true) {
      _log.fine("no cached tweets exist");
      // if no cached tweet exists wait for the initial api call
      await updateTweets();
    } else {
      _log.fine("got cached tweets");
      // if cached tweets exist update tweets but dont wait for it
      loadingInitialTweets = false;
      updateTweets();
    }
  }

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

  void addNewTweets(List<Tweet> newTweets) {
    // filter tweets that are already in the tweets list
    final List<Tweet> filteredTweets =
        newTweets.where((tweet) => !tweets.contains(tweet)).toList();

    tweets.addAll(sortTweetReplies(filteredTweets));
    // todo: maybe have to cache the tweets after sorting?
  }
}
