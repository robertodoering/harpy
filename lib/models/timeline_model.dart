import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

/// Abstraction for the [HomeTimelineModel] and the [UserTimelineModel].
///
/// Holds the [tweets] of the timeline and common actions for the
/// [tweetService].
abstract class TimelineModel extends Model {
  TimelineModel({
    @required this.tweetService,
    @required this.tweetCache,
  }) : assert(tweetCache != null);

  final TweetService tweetService;
  final TweetCache tweetCache;

  static final Logger _log = Logger("TimelineModel");

  /// The [tweets] for this timeline.
  List<Tweet> tweets = [];

  Future<void> initTweets() async {
    _log.fine("initializing tweets");

    // initialize with cached tweets
    tweets = await tweetCache.getCachedTweets();

    if (tweets.isEmpty) {
      _log.fine("no cached tweets exist");
      // if no cached tweet exists wait for the initial api call
      await updateTweets();
    } else {
      _log.fine("got cached tweets");
      // if cached tweets exist update tweets but dont wait for it
      updateTweets();
    }
  }

  Future<void> updateTweets();
}
