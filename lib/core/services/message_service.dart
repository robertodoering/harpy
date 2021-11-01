import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class MessageService {
  const MessageService();

  HarpyMessageState get messageState => HarpyMessage.globalKey.currentState!;

  /// Shows a global [SnackBar] using the [HarpyMessage].
  void show(String message, [SnackBarAction? action]) =>
      messageState.show(message);

  /// Shows a global custom [snackBar]using the [HarpyMessage].
  void showCustom(SnackBar snackBar) => messageState.showCustom(snackBar);
}
