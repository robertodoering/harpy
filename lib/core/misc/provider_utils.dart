import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AutoDisposeRefExtension on AutoDisposeRef<dynamic> {
  /// When invoked keeps your provider alive for [duration].
  // TODO: replace with cacheTime once available: https://github.com/rrousselGit/riverpod/issues/1664
  void cacheFor(Duration duration) {
    final link = keepAlive();
    final timer = Timer(duration, link.close);
    onDispose(timer.cancel);
  }
}
