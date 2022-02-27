import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

final harpyVideoPlayerHandlerProvider = Provider.autoDispose(
  (ref) => HarpyVideoPlayerHandler(),
  name: 'HarpyVideoPlayerHandlerProvider',
);

/// registers HarpyVideoPlayerController
///
/// eg. pauseAll()
class HarpyVideoPlayerHandler {
  final List<HarpyVideoPlayerNotifier> _notifiers = [];

  void add(HarpyVideoPlayerNotifier notifier) {
    _notifiers.add(notifier);
  }

  void remove(HarpyVideoPlayerNotifier notifier) {
    _notifiers.remove(notifier);
  }

  void act(ValueChanged<HarpyVideoPlayerNotifier> act) {
    _notifiers.forEach(act);
  }
}
