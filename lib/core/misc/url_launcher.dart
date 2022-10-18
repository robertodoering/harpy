import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

typedef UrlLauncher = void Function(
  String url, {
  bool alwaysOpenExternally,
});

final launcherProvider = Provider<UrlLauncher>(
  (ref) => (url, {alwaysOpenExternally = false}) {
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
      if (shouldOpenExternally) {
        launchUrl(uri, mode: LaunchMode.externalApplication).ignore();
      } else {
        ref.read(routerProvider).pushNamed(
          WebviewPage.name,
          queryParams: {
            'initialUrl': url,
          },
        );
      }
    } catch (e) {
      Logger('UrlLauncher').warning('cant launch url $url', e);
    }
  },
);
