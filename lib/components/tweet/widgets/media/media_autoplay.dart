import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

/// Starts initialization for a video player when the child becomes visible.
///
/// Requires a [VisibilityChangeListener] to be built above this widget.
class MediaAutoplay extends ConsumerStatefulWidget {
  const MediaAutoplay({
    required this.child,
    required this.state,
    required this.notifier,
    required this.enableAutoplay,
  });

  final Widget child;
  final VideoPlayerState state;
  final VideoPlayerNotifier notifier;
  final bool enableAutoplay;

  @override
  ConsumerState<MediaAutoplay> createState() => _MediaAutoplayState();
}

class _MediaAutoplayState extends ConsumerState<MediaAutoplay> {
  bool _visible = false;

  VisibilityChange? _visibilityChange;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _visibilityChange ??= VisibilityChange.of(context)
      ?..addCallback(_onVisibilityChanged);

    assert(_visibilityChange != null);
  }

  @override
  void dispose() {
    _visibilityChange?.removeCallback(_onVisibilityChanged);

    super.dispose();
  }

  Future<void> _onVisibilityChanged(bool visible) async {
    _visible = visible;

    if (mounted && visible && widget.enableAutoplay) {
      // wait a second to see whether this tweet is still visible before
      // initializing the video
      await Future<void>.delayed(const Duration(seconds: 1));

      if (mounted &&
          _visible &&
          widget.state is VideoPlayerStateUninitialized) {
        await widget.notifier.initialize(volume: 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
