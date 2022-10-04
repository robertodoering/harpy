import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/settings/media/preferences/media_preferences.dart';
import 'package:harpy/components/webview/webview_page.dart';
import 'package:harpy/core/core.dart';
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

    try {
      if (shouldOpenExternally) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
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
