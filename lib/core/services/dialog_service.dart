import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/core/core.dart';

final dialogServiceProvider = Provider(
  (ref) => DialogService(read: ref.read),
  name: 'DialogServiceProvider',
);

class DialogService {
  const DialogService({
    required Reader read,
  }) : _read = read;

  final Reader _read;

  Future<T?> show<T extends Object>({required Widget child}) async {
    assert(_read(routerProvider).navigator != null);

    return showDialog<T>(
      context: _read(routerProvider).navigator!.context,
      builder: (_) => child,
    );
  }
}
