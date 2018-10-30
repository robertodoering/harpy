import 'package:harpy/api/twitter/twitter_client.dart';

abstract class TwitterService {
  TwitterClient _twitterClient = TwitterClient();

  TwitterClient get client => _twitterClient;
}
