import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweets/tweet_service.dart';
import 'package:harpy/api/twitter/services/twitter_service.dart';
import 'package:harpy/core/json/json_mapper.dart';

class TweetServiceImpl extends TwitterService
    with JsonMapper<Tweet>
    implements TweetService {
  @override
  Future<List<Tweet>> getHomeTimeline() async {
    final response = await client.get(
        "https://api.twitter.com/1.1/statuses/home_timeline.json?count=100");

    if (response.statusCode == 200) {
      List<Tweet> tweets = map((map) {
        return Tweet.fromJson(map);
      }, response.body);
      return Future<List<Tweet>>(() => tweets);
    } else {
      return Future.error(response.body);
    }
  }

  @override
  Future retweet(String tweetId) async {
    final response = await client
        .post("https://api.twitter.com/1.1/statuses/retweet/$tweetId.json");

    return handleResponse(response);
  }

  @override
  Future unretweet(String tweetId) async {
    final response = await client
        .post("https://api.twitter.com/1.1/statuses/unretweet/$tweetId.json");

    return handleResponse(response);
  }

  @override
  Future favorite(String tweetId) async {
    final response = await client
        .post("https://api.twitter.com/1.1/favorites/create.json?id=$tweetId");

    return handleResponse(response);
  }

  @override
  Future unfavorite(String tweetId) async {
    final response = await client
        .post("https://api.twitter.com/1.1/favorites/destroy.json?id=$tweetId");

    return handleResponse(response);
  }
}
