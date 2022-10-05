import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/settings/media/preferences/media_preferences.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

typedef UrlLauncher = Future<void> Function(
  String url, {
  bool alwaysOpenExternally,
});

final launcherProvider = Provider<UrlLauncher>(
  (ref) => (url, {alwaysOpenExternally = false}) async {
    final shouldOpenExternally = alwaysOpenExternally ||
        ref.read(mediaPreferencesProvider).openLinksExternally;

    var uri = Uri.parse(url);
    if (shouldOpenExternally && uri.host == 'twitter.com') {
      // When harpy is set to open twitter urls we can't open twitter urls
      // externally anymore. Instead we change the host to mobile.twitter.com
      // which we are not set to open.
      uri = uri.replace(host: 'mobile.twitter.com');
    }

    try {
      await launchUrl(
        uri,
        mode: shouldOpenExternally
            ? LaunchMode.externalApplication
            : LaunchMode.inAppWebView,
      );
    } catch (e) {
      Logger('UrlLauncher').warning('cant launch url $url', e);
    }
  },
);
