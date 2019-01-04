import 'package:http/http.dart';
import 'package:logging/logging.dart';

class TwitterService {
  final Logger log = Logger("TwitterService");

  Future handleResponse(
    Response response, {
    onSuccess(Response response) = null,
    onFail(Response response) = null,
  }) async {
    log.fine("response status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      if (onSuccess != null) {
        return onSuccess(response);
      } else {
        return Future<Response>(() => response);
      }
    } else {
      if (onFail != null) {
        return onFail(response);
      } else {
        return Future.error(response.body);
      }
    }
  }
}
