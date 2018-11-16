import 'package:harpy/api/twitter/data/tweet.dart';

abstract class TweetService {
  Future<List<Tweet>> getHomeTimeline();

  Future<void> unretweet(String tweetId);

  Future<void> favorite(String tweetId);

  Future<void> unfavorite(String tweetId);

  Future<void> retweet(String tweetId);
}
