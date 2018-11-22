import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrl(String url) async {
  if (await canLaunch(url)) {
    Logger("launchUrl").fine("launching url $url");
    await launch(url);
  } else {
    Logger("launchUrl").warning("cant launch url $url");
    return Future.error(null);
  }
}
