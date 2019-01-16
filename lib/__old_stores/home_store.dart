import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:harpy/__old_stores/tweet_store_mixin.dart';
import 'package:logging/logging.dart';

class HomeStore extends Store with TweetStoreMixin {
  final Logger log = Logger("HomeStore");

  static final Action initTweets = Action();
  static final Action updateTweets = Action();
  static final Action clearCache = Action();
  static final Action<String> tweetsAfter = Action();

  static final Action<Tweet> favoriteTweetAction = Action();
  static final Action<Tweet> unfavoriteTweetAction = Action();
  static final Action<Tweet> retweetTweetAction = Action();
  static final Action<Tweet> unretweetTweetAction = Action();

  static final Action<Tweet> showTweetMediaAction = Action();
  static final Action<Tweet> hideTweetMediaAction = Action();

  static final Action<Tweet> translateTweetAction = Action();

  static final Action<Tweet> updateTweet = Action();

  List<Tweet> _tweets;

  List<Tweet> get tweets => _tweets;

  HomeStore() {
    /*
     * tweets
     */
    initTweets.listen((_) async {
      log.fine("init tweets");

      // initialize with cached tweets
      _tweets = await TweetCache.home().getCachedTweets();

      if (_tweets.isEmpty) {
        // if no cached tweet exists wait for the initial api call
        await updateTweets();
      } else {
        // if cached tweets exist update tweets but dont wait for it
        updateTweets();
      }
    });

    triggerOnAction(updateTweets, (_) async {
      log.fine("updating tweets");

      // todo: disable actions while updating user tweets

      _tweets = await TweetService().getHomeTimeline();
    });

    triggerOnAction(tweetsAfter, (String id) async {
      id = (int.parse(id) - 1).toString();

      log.fine("getting tweets with max id $id");

      _tweets.addAll(await TweetService().getHomeTimeline(
        params: {"max_id": id},
      ));
    });

    clearCache.listen((_) => TweetCache.home().clearBucket());

    /*
     * actions
     */
    onTweetUpdated = (tweet) {
      TweetCache.home().updateTweet(tweet);
    };

    // used by user store to update a tweet
    triggerOnAction(updateTweet, (Tweet tweet) {
      int index = _tweets.indexOf(tweet);

      if (index != -1) {
        log.fine("update home timeline tweet");
        _tweets[index] = tweet;
      }

      onTweetUpdated(tweet);
    });

    triggerOnAction(favoriteTweetAction, (Tweet tweet) {
      favoriteTweet(tweet);
    });

    triggerOnAction(unfavoriteTweetAction, (Tweet tweet) {
      unfavoriteTweet(tweet);
    });

    triggerOnAction(retweetTweetAction, (Tweet tweet) {
      retweetTweet(tweet);
    });

    triggerOnAction(unretweetTweetAction, (Tweet tweet) {
      unretweetTweet(tweet);
    });

    showTweetMediaAction.listen((Tweet tweet) {
      showTweetMedia(tweet);
    });

    hideTweetMediaAction.listen((Tweet tweet) {
      hideTweetMedia(tweet);
    });

    triggerOnAction(translateTweetAction, (Tweet tweet) async {
      await translateTweet(tweet);
    });
  }
}
