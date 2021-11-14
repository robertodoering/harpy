import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/auth/twitter_auth.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef OnExternalNavigation = void Function(String url);

/// Builds a [WebView] for the twitter authentication.
///
/// Upon successful authentication or user cancel, [Navigator.pop] will be
/// called with the callback url as a [Uri] instance.
/// The callback url contains the token and secret as query params on
/// success, or a denied query param on user cancel.
class TwitterLoginWebview extends StatefulWidget {
  const TwitterLoginWebview({
    required this.token,
    required this.onExternalNavigation,
  });

  final String token;
  final OnExternalNavigation onExternalNavigation;

  @override
  _TwitterLoginWebviewState createState() => _TwitterLoginWebviewState();
}

class _TwitterLoginWebviewState extends State<TwitterLoginWebview> {
  @override
  void initState() {
    super.initState();

    WebView.platform = SurfaceAndroidWebView();
  }

  NavigationDecision _navigationDelegate(
    BuildContext context,
    NavigationRequest navigation,
  ) {
    if (navigation.url.startsWith(TwitterAuth.callbackUrl)) {
      // received callback - pop navigator with callback url
      Navigator.of(context).pop(Uri.dataFromString(navigation.url));
      return NavigationDecision.prevent;
    } else {
      if ([
        'twitter.com/oauth/authorize', // login page
        'api.twitter.com/login/error', // login error (e.g. invalid username / password)
        'api.twitter.com/account/login_verification' // 2 factor authentication
      ].any(navigation.url.contains)) {
        // stay in in-app webview
        return NavigationDecision.navigate;
      } else {
        // when navigating away from the sign in page (help page, signup
        // page, etc.)
        // used to open external browser
        widget.onExternalNavigation(navigation.url);
        return NavigationDecision.prevent;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialUrl = Uri.https(
      'api.twitter.com',
      'oauth/authorize',
      <String, String>{
        'force_login': 'true',
        'oauth_token': widget.token,
      },
    );

    return WebView(
      initialUrl: initialUrl.toString(),
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: (navigation) => _navigationDelegate(
        context,
        navigation,
      ),
    );
  }
}
