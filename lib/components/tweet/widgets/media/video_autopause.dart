import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// Uses the [VideoPlayerHandler] to automatically pause every active video on
/// navigation.
class VideoAutopause extends ConsumerStatefulWidget {
  const VideoAutopause({
    required this.child,
  });

  final Widget child;

  @override
  _VideoAutopauseState createState() => _VideoAutopauseState();
}

class _VideoAutopauseState extends ConsumerState<VideoAutopause>
    with RouteAware {
  RouteObserver? _observer;

  @override
  void didPushNext() {
    ref.read(videoPlayerHandlerProvider).act((notifier) => notifier.pause());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _observer ??= ref.read(routeObserver)
      ?..subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _observer?.unsubscribe(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
