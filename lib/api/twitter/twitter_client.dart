import 'dart:convert';

import 'package:harpy/core/app_configuration.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:http/http.dart';
import 'package:oauth1/oauth1.dart' as OAuth1;

class TwitterClient {
  OAuth1.Platform _oauthPlatform;
  var _oauthClientCredentials;
  var _auth;

  OAuth1.Client _client;

  TwitterClient() {
    _oauthPlatform = OAuth1.Platform(
        'https://api.twitter.com/oauth/request_token',
        'https://api.twitter.com/oauth/authorize',
        'https://api.twitter.com/oauth/access_token',
        OAuth1.SignatureMethods.HMAC_SHA1);
    _oauthClientCredentials = OAuth1.ClientCredentials(
        AppConfiguration().applicationConfig.consumerKey,
        AppConfiguration().applicationConfig.consumerSecret);

    _auth = OAuth1.Authorization(_oauthClientCredentials, _oauthPlatform);

    _client = OAuth1.Client(
        _oauthPlatform.signatureMethod,
        _oauthClientCredentials,
        OAuth1.Credentials(AppConfiguration().twitterSession.token,
            AppConfiguration().twitterSession.secret));
  }

  Future<Response> get(
    String url, {
    Map<String, String> headers,
    Map<String, String> params,
  }) {
    url = appendParamsToUrl(url, params);
    return _client.get(url, headers: headers);
  }

  Future<Response> post(
    String url, {
    Map<String, String> headers,
    dynamic body,
    Encoding encoding,
  }) {
    return _client.post(url, headers: headers, body: body, encoding: encoding);
  }
}
