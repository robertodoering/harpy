import 'package:harpy/api/twitter/data/tweet.dart';

abstract class TweetService {
  Future<List<Tweet>> getHomeTimeline();
}
