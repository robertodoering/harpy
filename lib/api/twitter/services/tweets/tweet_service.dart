import 'package:harpy/api/twitter/data/tweet.dart';

abstract class TweetService {
  Future<List<Tweet>> getHomeTimeline();

  Future<List<Tweet>> getUserTimeline();

  Future unretweet(String tweetId);

  Future favorite(String tweetId);

  Future unfavorite(String tweetId);

  Future retweet(String tweetId);
}
