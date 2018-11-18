import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

abstract class TwitterService {
  final Logger log = Logger('TwitterService');
  TwitterClient _twitterClient = TwitterClient();

  TwitterClient get client => _twitterClient;

  Future handleResponse(
    Response response, {
    onSuccess(Response response) = null,
    onFail(Response response) = null,
  }) async {
    log.fine("response status code: ${response.statusCode}");

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
