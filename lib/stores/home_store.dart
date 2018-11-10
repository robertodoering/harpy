import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweets/cached_tweet_service_impl.dart';
import 'package:harpy/api/twitter/services/tweets/tweet_service_impl.dart';

class HomeStore extends Store {
  static final Action initTweets = Action();
  static final Action updateTweets = Action();

  List<Tweet> _tweets;

  List<Tweet> get tweets => _tweets;

  HomeStore() {
    initTweets.listen((_) async {
      _tweets = await CachedTweetServiceImpl().getHomeTimeline();
    });

    triggerOnAction(updateTweets, (_) async {
      print("updating tweets");
      _tweets = await TweetServiceImpl().getHomeTimeline();

      print("updated tweets: $tweets");
    });
  }
}
