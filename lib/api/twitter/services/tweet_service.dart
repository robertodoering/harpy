import 'package:harpy/api/twitter/services/twitter_service.dart';
import 'package:http/http.dart' as http;
//TODO remove

class TweetService extends TwitterService {
  Future<http.Response> getHomeTimeline() async {
    final response = await client
        .get("https://api.twitter.com/1.1/statuses/home_timeline.json");

    if (response.statusCode == 200) {
      return response;
    } else {
      return Future.error(response.body);
    }
  }
}
