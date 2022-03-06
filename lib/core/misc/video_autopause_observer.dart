import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final videoAutopauseObserver = Provider(
  (ref) => VideoAutopauseObserver(
    read: ref.read,
  ),
  name: 'VideoAutopauseObserver',
);

/// Uses the [VideoPlayerHandler] to automatically pause every active video on
/// navigation.
class VideoAutopauseObserver extends RouteObserver {
  VideoAutopauseObserver({
    required Reader read,
  }) : _read = read;

  final Reader _read;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    if (route is! HeroDialogRoute) {
      _read(videoPlayerHandlerProvider).act((notifier) => notifier.pause());
    }
  }
}
