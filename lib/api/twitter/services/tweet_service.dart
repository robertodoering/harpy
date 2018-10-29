import 'package:harpy/api/http.dart';
import 'package:harpy/api/twitter/twitter_auth_dispatcher.dart';
import 'package:http/http.dart' as http;
//TODO remove

class TweetService {
  Future<http.Response> getTweets(String accessToken) async {
    Http http = Http();
    http.dispatcher = TwitterAuthDispatcher();

    final response = await http
        .get("https://api.twitter.com/1.1/statuses/home_timeline.json");

    if (response.statusCode == 200) {
      return response;
    } else {
      return Future.error(response.body);
    }
  }
}
