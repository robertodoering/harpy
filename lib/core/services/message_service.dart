import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/core/core.dart';

final messageServiceProvider = Provider(
  (ref) => MessageService(read: ref.read),
  name: 'MessageServiceProvider',
);

class MessageService {
  const MessageService({
    required Reader read,
  }) : _read = read;

  final Reader _read;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showText(
    String text,
  ) {
    return showSnackbar(SnackBar(content: Text(text)));
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackbar(
    SnackBar snackBar,
  ) {
    final context = _read(routerProvider).navigator?.context;
    assert(context != null);

    if (context != null) {
      final messenger = ScaffoldMessenger.maybeOf(context);
      assert(messenger != null);

      return messenger?.showSnackBar(snackBar);
    } else {
      return null;
    }
  }
}
