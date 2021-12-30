import 'package:harpy/api/twitter/auth/twitter_auth_result.dart';
import 'package:harpy/api/twitter/auth/twitter_login_webview.dart';
import 'package:oauth1/oauth1.dart';

/// Used to navigate to the [TwitterLoginWebview] and return it's result.
typedef WebviewNavigation = Future<Uri?> Function(TwitterLoginWebview webview);

/// Handles web view based oauth1 authentication with Twitter using
/// [TwitterLoginWebview].
class TwitterAuth {
  TwitterAuth({
    required this.consumerKey,
    required this.consumerSecret,
  }) : _auth = Authorization(
          ClientCredentials(consumerKey, consumerSecret),
          Platform(
            'https://api.twitter.com/oauth/request_token',
            'https://api.twitter.com/oauth/authorize',
            'https://api.twitter.com/oauth/access_token',
            SignatureMethods.hmacSha1,
          ),
        );

  final String consumerKey;
  final String consumerSecret;

  final Authorization _auth;

  static const callbackUrl = 'harpy://';

  /// Starts the 3-legged oauth flow to retrieve the user access tokens.
  ///
  /// Returns a [TwitterAuthResult] with a [TwitterAuthStatus.success] and a
  /// [TwitterAuthSession] when the user successfully authenticated.
  ///
  /// When the [TwitterAuthResult.status] is not [TwitterAuthStatus.success],
  /// [TwitterAuthResult.session] will be `null` and an unsuccessful
  /// authentication should be assumed.
  ///
  /// See https://developer.twitter.com/en/docs/authentication/oauth-1-0a/obtaining-user-access-tokens.
  Future<TwitterAuthResult> authenticateWithTwitter({
    required WebviewNavigation webviewNavigation,
    required OnExternalNavigation onExternalNavigation,
  }) async {
    try {
      final tempCredentialsResponse =
          await _auth.requestTemporaryCredentials(callbackUrl);

      final authCallback = await webviewNavigation(
        TwitterLoginWebview(
          token: tempCredentialsResponse.credentials.token,
          onExternalNavigation: onExternalNavigation,
        ),
      );

      return _requestTokenCredentials(authCallback);
    } catch (e) {
      return TwitterAuthResult(status: TwitterAuthStatus.failure);
    }
  }

  Future<TwitterAuthResult> _requestTokenCredentials(Uri? authCallback) async {
    final userCancelled = authCallback == null ||
        authCallback.queryParameters.containsKey('denied');

    if (!userCancelled) {
      final oauthToken = authCallback.queryParameters['oauth_token'];
      final oauthVerifier = authCallback.queryParameters['oauth_verifier'];

      if (oauthToken != null && oauthVerifier != null) {
        final credentialsResponse = await _auth.requestTokenCredentials(
          Credentials(oauthToken, ''),
          oauthVerifier,
        );

        final token = credentialsResponse.credentials.token;
        final tokenSecret = credentialsResponse.credentials.tokenSecret;
        final userId = token.split('-').first;

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
  }
}
