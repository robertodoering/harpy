import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:http/http.dart';

abstract class TwitterService {
  TwitterClient _twitterClient = TwitterClient();

  TwitterClient get client => _twitterClient;

  handleResponse(Response response,
      {onSuccess(Response response) = null, onFail(Response response) = null}) {
    if (response.statusCode == 200) {
      if (onSuccess != null) {
        onSuccess(response);
      } else {
        return Future<Response>(() => response);
      }
    } else {
      if (onFail != null) {
        onFail(response);
      } else {
        return Future.error(response.body);
      }
    }
  }
}
