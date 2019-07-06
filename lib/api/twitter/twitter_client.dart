import 'dart:convert';
import 'dart:io';

import 'package:harpy/core/utils/string_utils.dart';
import 'package:harpy/models/application_model.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:path_provider/path_provider.dart';

class TwitterClient {
  static final Logger _log = Logger("TwitterClient");

  static const Duration _timeout = Duration(seconds: 20);

  ApplicationModel applicationModel;

  oauth1.Platform get _platform {
    return oauth1.Platform(
      'https://api.twitter.com/oauth/request_token',
      'https://api.twitter.com/oauth/authorize',
      'https://api.twitter.com/oauth/access_token',
      oauth1.SignatureMethods.hmacSha1,
    );
  }

  oauth1.ClientCredentials get _clientCredentials {
    assert(applicationModel != null);
    assert(applicationModel.twitterLogin != null);

    return oauth1.ClientCredentials(
      applicationModel.twitterLogin.consumerKey,
      applicationModel.twitterLogin.consumerSecret,
    );
  }

  oauth1.Client get _client {
    assert(applicationModel != null);
    assert(applicationModel.twitterSession != null);

    return oauth1.Client(
      _platform.signatureMethod,
      _clientCredentials,
      oauth1.Credentials(
        applicationModel.twitterSession.token,
        applicationModel.twitterSession.secret,
      ),
    );
  }

  /// Saves the response on the device as a file for debugging.
  Future<void> _saveResponse(Response response) async {
    print("saving response");
    final dir = await getApplicationDocumentsDirectory();

    final String url =
        response.request.url.toString().split("/").last.split("?").first;
    final String time = DateTime.now().toIso8601String();

    final String path = "${dir.path}/responses/${time}_$url";
    File(path)
      ..createSync(recursive: true)
      ..writeAsStringSync(response.body);
    print("response saved in $path");
  }

  Future<Response> get(
    String url, {
    Map<String, String> headers,
    Map<String, String> params,
  }) {
    _log.fine("sending get request: $url");
    url = appendParamsToUrl(url, params);

    return _client
        .get(url, headers: headers)
        .timeout(_timeout)
        .then((response) {
//      _saveResponse(response);
      if (response.statusCode != 200) return Future.error(response);
      return response;
    });
  }

  Future<Response> post(
    String url, {
    Map<String, String> headers,
    Map<String, String> params,
    dynamic body,
    Encoding encoding,
  }) {
    _log.fine("sending post request: $url");
    url = appendParamsToUrl(url, params);

    return _client
        .post(url, headers: headers, body: body, encoding: encoding)
        .timeout(_timeout)
        .then((response) {
//      _saveResponse(response);
      return response;
    });
  }
}
