import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:scoped_model/scoped_model.dart';

class TimelineModel extends Model {
  TimelineModel() {}

  List<Tweet> tweets = [];

  Future<void> initTweets() async {
    // initialize with cached tweets
    tweets = await TweetCache.home().getCachedTweets();

    if (tweets.isEmpty) {
      // if no cached tweet exists wait for the initial api call
      await updateTweets();
    } else {
      notifyListeners();
      // if cached tweets exist update tweets but dont wait for it
      updateTweets();
    }
  }

  Future<void> updateTweets() async {
    // todo: disable actions while updating user tweets

    tweets = await TweetService().getHomeTimeline();
    notifyListeners();
  }
}
