import 'dart:convert';

import 'package:harpy/core/utils/string_utils.dart';
import 'package:harpy/models/application_model.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

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

  Future<Response> get(
    String url, {
    Map<String, String> headers,
    Map<String, String> params,
  }) {
    _log.fine("sending get request: $url");
    url = appendParamsToUrl(url, params);
    return _client.get(url, headers: headers);
  }

  Future<Response> post(
    String url, {
    Map<String, String> headers,
    dynamic body,
    Encoding encoding,
  }) {
    _log.fine("sending post request: $url");
    return _client.post(url, headers: headers, body: body, encoding: encoding);
  }
}
