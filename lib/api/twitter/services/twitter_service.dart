import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:http/http.dart';

abstract class TwitterService {
  TwitterClient _twitterClient = TwitterClient();

  TwitterClient get client => _twitterClient;

  handleResponse(Response response, onSuccess(Response response),
      {onFail() = null}) {
    if (response.statusCode == 200) {
      onSuccess(response);
    } else {
      if (onFail != null) {
        onFail();
      } else {
        return Future.error(response.body);
      }
    }
  }
}
