import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class MessageService {
  HarpyMessageState get messageState => HarpyMessage.globalKey.currentState;

  /// Shows a global [SnackBar] using the [HarpyMessage].
  void show(String message, [SnackBarAction action]) =>
      messageState.show(message);
}
