import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:meta/meta.dart';

abstract class TweetService {
  Future<List<Tweet>> getHomeTimeline();

  Future<List<Tweet>> getUserTimeline(String userId);

  Future unretweet(String tweetId);

  Future favorite(String tweetId);

  Future unfavorite(String tweetId);

  Future retweet(String tweetId);

  Future createTweet({@required String text, List<String> mediaIds});
}
