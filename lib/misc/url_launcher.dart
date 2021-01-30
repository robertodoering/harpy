import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

final Logger _log = Logger('UrlLauncher');

Future<void> launchUrl(String url) async {
  try {
    await launch(url);
  } catch (e) {
    _log.warning('cant launch url $url', e);
    app<MessageService>().show('unable to launch $url');
  }
}
