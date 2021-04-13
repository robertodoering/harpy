import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/auth/twitter_auth_result.dart';
import 'package:harpy/api/twitter/auth/twitter_login_webview.dart';
import 'package:oauth1/oauth1.dart';

typedef WebviewNavigation = Future<Uri> Function(Widget webview);

class TwitterAuth {
  TwitterAuth({
    @required String consumerKey,
    @required String consumerSecret,
  }) : _auth = Authorization(
          ClientCredentials(consumerKey, consumerSecret),
          Platform(
            'https://api.twitter.com/oauth/request_token',
            'https://api.twitter.com/oauth/authorize',
            'https://api.twitter.com/oauth/access_token',
            SignatureMethods.hmacSha1,
          ),
        );

  final Authorization _auth;

  static const String callbackUrl = 'harpy://';

  Future<TwitterAuthResult> authenticateWithTwitter(
    WebviewNavigation webviewNavigation,
  ) async {
    try {
      final AuthorizationResponse tempCredentialsResponse =
          await _auth.requestTemporaryCredentials(callbackUrl);

      final Uri authCallback = await webviewNavigation(
        TwitterLoginWebview(token: tempCredentialsResponse.credentials.token),
      );

      final bool userCancelled = authCallback == null ||
          authCallback.queryParameters.containsKey('denied');

      if (!userCancelled) {
        final String oauthToken = authCallback.queryParameters['oauth_token'];
        final String oauthVerifier =
            authCallback.queryParameters['oauth_verifier'];

        if (oauthToken != null && oauthVerifier != null) {
          final AuthorizationResponse credentialsResponse =
              await _auth.requestTokenCredentials(
            Credentials(oauthToken, ''),
            oauthVerifier,
          );

          final String token = credentialsResponse.credentials.token;
          final String tokenSecret =
              credentialsResponse.credentials.tokenSecret;
          final String userId = token.split('-').first;

          return TwitterAuthResult(
            status: TwitterAuthStatus.success,
            session: TwitterAuthSession(
              token: token,
              tokenSecret: tokenSecret,
              userId: userId,
            ),
          );
        } else {
          // invalid auth callback
          return TwitterAuthResult(status: TwitterAuthStatus.failure);
        }
      } else {
        // user cancelled
        return TwitterAuthResult(status: TwitterAuthStatus.userCancelled);
      }
    } catch (e) {
      return TwitterAuthResult(status: TwitterAuthStatus.failure);
    }
  }
}
