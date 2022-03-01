import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

final videoPlayerHandlerProvider = Provider.autoDispose(
  (ref) => VideoPlayerHandler(),
  name: 'VideoPlayerHandlerProvider',
);

class VideoPlayerHandler {
  final List<VideoPlayerNotifier> _notifiers = [];

  void add(VideoPlayerNotifier notifier) {
    _notifiers.add(notifier);
  }

  void remove(VideoPlayerNotifier notifier) {
    _notifiers.remove(notifier);
  }

  void act(ValueChanged<VideoPlayerNotifier> act) {
    _notifiers.forEach(act);
  }
}
