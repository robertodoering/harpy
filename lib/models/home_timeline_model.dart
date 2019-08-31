import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/error_handler.dart';
import 'package:harpy/models/timeline_model.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class HomeTimelineModel extends TimelineModel {
  static HomeTimelineModel of(context) {
    return Provider.of<HomeTimelineModel>(context);
  }

  static final Logger _log = Logger("HomeTimelineModel");

  @override
  Future<List<Tweet>> getCachedTweets() {
    return timelineDatabase.findHomeTimelineTweets();
  }

  @override
  Future<void> updateTweets() async {
    _log.fine("updating tweets");

    final List<Tweet> updatedTweets = await tweetService
        .getHomeTimeline()
        .catchError(twitterClientErrorHandler);

    if (updatedTweets != null) {
      tweets = updatedTweets;
      timelineDatabase.addHomeTimelineIds(updatedTweets, limit: 100);
      tweetDatabase
          .recordTweetList(updatedTweets)
          .then((_) => tweetDatabase.limitRecordedTweets(
                limit: 1000,
                targetAmount: 500,
              ));
    }

    notifyListeners();
  }

  @override
  Future<void> requestMore() async {
    await super.requestMore();

    final id = "${tweets.last.id - 1}";

    final List<Tweet> newTweets = await tweetService
        .getHomeTimeline(maxId: id)
        .catchError(twitterClientErrorHandler);

    if (newTweets != null) {
      // todo: maybe add new tweets to cached home timeline ids
      addNewTweets(newTweets);
    }

    requestingMore = false;
    notifyListeners();
  }

  void updateTweet(Tweet tweet) {
    final int index = tweets.indexOf(tweet);
    if (index != -1) {
      _log.fine("updating home timeline tweet");
      tweets[index] = tweet;
    }
    notifyListeners();
  }
}
