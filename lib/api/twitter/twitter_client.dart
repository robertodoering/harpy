import 'dart:convert';

import 'package:harpy/core/config/app_configuration.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

class TwitterClient {
  final Logger log = Logger("TwitterClient");

  oauth1.Platform _platform;
  oauth1.ClientCredentials _clientCredentials;
  oauth1.Authorization _authorization;
  oauth1.Client client;

  static TwitterClient _instance = TwitterClient._();
  factory TwitterClient() => _instance;

  TwitterClient._() {
    _platform = oauth1.Platform(
      'https://api.twitter.com/oauth/request_token',
      'https://api.twitter.com/oauth/authorize',
      'https://api.twitter.com/oauth/access_token',
      oauth1.SignatureMethods.HMAC_SHA1,
    );

    _clientCredentials = oauth1.ClientCredentials(
      AppConfiguration().consumerKey,
      AppConfiguration().consumerSecret,
    );

    _authorization = oauth1.Authorization(_clientCredentials, _platform);

    client = oauth1.Client(
      _platform.signatureMethod,
      _clientCredentials,
      oauth1.Credentials(
        AppConfiguration().twitterSession.token,
        AppConfiguration().twitterSession.secret,
      ),
    );
  }

  Future<Response> get(
    String url, {
    Map<String, String> headers,
    Map<String, String> params,
  }) {
    url = appendParamsToUrl(url, params);
    log.fine("sending get request: $url");
    return client.get(url, headers: headers);
  }

  Future<Response> post(
    String url, {
    Map<String, String> headers,
    dynamic body,
    Encoding encoding,
  }) {
    log.fine("sending post request: $url");
    return client.post(url, headers: headers, body: body, encoding: encoding);
  }
}
