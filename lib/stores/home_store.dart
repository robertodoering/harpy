import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweets/cached_tweet_service_impl.dart';
import 'package:harpy/api/twitter/services/tweets/tweet_service_impl.dart';
import 'package:harpy/core/cache/tweet_cache.dart';

class HomeStore extends Store {
  static final Action initTweets = Action();
  static final Action updateTweets = Action();
  static final Action clearCache = Action();

  List<Tweet> _tweets;

  List<Tweet> get tweets => _tweets;

  HomeStore() {
    initTweets.listen((_) async {
      _tweets = await CachedTweetServiceImpl().getHomeTimeline();
    });

    triggerOnAction(updateTweets, (_) async {
      // todo: use cached tweet service updateHomeTimeline when implemented
      _tweets = await TweetServiceImpl().getHomeTimeline();
    });

    clearCache.listen((_) => TweetCache().clearCache());
  }
}
