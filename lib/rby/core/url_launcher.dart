import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launch(String url) async {
  try {
    await launchUrl(Uri.parse(url));
  } catch (e) {
    Logger('UrlLauncher').warning('cant launch url $url', e);
  }
}
