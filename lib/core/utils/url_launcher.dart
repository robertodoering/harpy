import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

final Logger log = Logger("UrlLauncher");

Future<void> launchUrl(String url) async {
  if (await canLaunch(url)) {
    log.fine("launching url $url");
    await launch(url);
  } else {
    log.warning("cant launch url $url");
    return Future.error(null);
  }
}
