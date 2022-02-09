import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/core/core.dart';

final dialogServiceProvider = Provider(
  DialogService.new,
  name: 'DialogServiceProvider',
);

class DialogService {
  const DialogService(this._ref);

  final Ref _ref;

  Future<T?> show<T>({required Widget child}) async {
    assert(_ref.read(routerProvider).navigator != null);

    return showDialog<T>(
      context: _ref.read(routerProvider).navigator!.context,
      builder: (_) => child,
    );
  }
}
