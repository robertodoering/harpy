import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/settings/media/preferences/media_preferences.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

final launcherProvider = Provider(
  (ref) => Launcher(
    read: ref.read,
  ),
);

class Launcher {
  const Launcher({
    required this.read,
  });

  final Reader read;

  Future<void> safeLaunchUrl(String url) async {
    final shouldOpenExternally =
        read(mediaPreferencesProvider).openLinksExternally;

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
  }
}
