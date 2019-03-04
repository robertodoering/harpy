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

  ApplicationModel applicationModel;

  oauth1.Platform get _platform {
    return oauth1.Platform(
      'https://api.twitter.com/oauth/request_token',
      'https://api.twitter.com/oauth/authorize',
      'https://api.twitter.com/oauth/access_token',
      oauth1.SignatureMethods.HMAC_SHA1,
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

  Future<void> _saveResponse(Response response) async {
    print("saving response");
    final dir = await getApplicationDocumentsDirectory();

    String url =
        response.request.url.toString().split("/").last.split("?").first;
    String time = DateTime.now().toIso8601String();

    String path = "${dir.path}/responses/${time}_$url";
    File file = File(path);
    file.createSync(recursive: true);
    file.writeAsStringSync(response.body);
    print("response saved in $path");
  }

  Future<Response> get(
    String url, {
    Map<String, String> headers,
    Map<String, String> params,
  }) {
    _log.fine("sending get request: $url");
    url = appendParamsToUrl(url, params);
    return _client.get(url, headers: headers).then((response) {
//      _saveResponse(response);
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
    return _client.post(url, headers: headers, body: body, encoding: encoding);
  }
}
