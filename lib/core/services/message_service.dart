import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/core/core.dart';

final messageServiceProvider = Provider(
  MessageService.new,
  name: 'MessageServiceProvider',
);

class MessageService {
  const MessageService(this._ref);

  final Ref _ref;

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
