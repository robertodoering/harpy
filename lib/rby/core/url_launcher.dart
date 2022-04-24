import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrl(String url) async {
  try {
    await launch(url);
  } catch (e) {
    Logger('UrlLauncher').warning('cant launch url $url', e);
  }
}
