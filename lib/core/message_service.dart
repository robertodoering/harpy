import 'package:harpy/components/common/misc/harpy_message.dart';
import 'package:harpy/components/common/misc/harpy_message_handler.dart';

/// Uses the [HarpyMessageHandler] to show info / warning / error messages at
/// the bottom of the screen.
///
/// The [MessageService] is instantiated once by the global service locator and
/// can easily be mocked in tests.
class MessageService {
  void showInfo(String text) {
    HarpyMessageHandler.globalKey.currentState.showMessage(
      HarpyMessage.info(text),
    );
  }

  void showWarning(String text) {
    HarpyMessageHandler.globalKey.currentState.showMessage(
      HarpyMessage.warning(text),
    );
  }

  void showError(String text) {
    HarpyMessageHandler.globalKey.currentState.showMessage(
      HarpyMessage.error(text),
    );
  }
}
