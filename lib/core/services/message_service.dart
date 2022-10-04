import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/core/core.dart';

final messageServiceProvider = Provider(
  (ref) => MessageService(ref: ref),
  name: 'MessageServiceProvider',
);

class MessageService {
  const MessageService({
    required Ref ref,
  }) : _ref = ref;

  final Ref _ref;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showText(
    String text,
  ) {
    return showSnackbar(SnackBar(content: Text(text)));
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackbar(
    SnackBar snackBar,
  ) {
    final context = _ref.read(routerProvider).navigator?.context;
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
