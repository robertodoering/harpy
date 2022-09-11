import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/settings/media/preferences/media_preferences.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

typedef UrlLauncher = Future<void> Function(String url);

final launcherProvider = Provider<UrlLauncher>(
  (ref) => (url) async {
    final shouldOpenExternally =
        ref.read(mediaPreferencesProvider).openLinksExternally;

    try {
      await launchUrl(
        Uri.parse(url),
        mode: shouldOpenExternally
            ? LaunchMode.externalApplication
            : LaunchMode.inAppWebView,
      );
    } catch (e) {
      Logger('UrlLauncher').warning('cant launch url $url', e);
    }
  },
);
