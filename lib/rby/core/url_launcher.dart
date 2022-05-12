import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> safeLaunchUrl(String url) async {
  try {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    Logger('UrlLauncher').warning('cant launch url $url', e);
  }
}
