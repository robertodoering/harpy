import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final videoAutopauseObserver = Provider(
  (ref) => VideoAutopauseObserver(
    ref: ref,
  ),
  name: 'VideoAutopauseObserver',
);

/// Uses the [VideoPlayerHandler] to automatically pause every active video on
/// navigation (with some exceptions).
class VideoAutopauseObserver extends RouteObserver {
  VideoAutopauseObserver({
    required Ref ref,
  }) : _ref = ref;

  final Ref _ref;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (route is! HeroDialogRoute && route is! ModalSheetRoute) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => _ref.read(videoPlayerHandlerProvider).act(
              (notifier) => notifier.pause(),
            ),
      );
    }
  }
}
