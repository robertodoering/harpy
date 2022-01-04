import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// Automatically initializes the parent [HarpyVideoPlayerModel] when the
/// [child] becomes visible.
///
/// A [VisibilityChangeDetector] needs to be built above this widget.
class VideoAutoplay extends StatefulWidget {
  const VideoAutoplay({
    required this.child,
    this.onAutoplay,
  });

  final Widget child;

  final VoidCallback? onAutoplay;

  @override
  _VideoAutoplayState createState() => _VideoAutoplayState();
}

class _VideoAutoplayState extends State<VideoAutoplay> {
  bool _visible = false;

  VisibilityChange? _visibilityChange;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _visibilityChange = VisibilityChange.of(context);

    assert(_visibilityChange != null);

    _visibilityChange?.addOnVisibilityChanged(
      _onVisibilityChanged,
    );
  }

  @override
  void dispose() {
    _visibilityChange?.removeOnVisibilityChanged(
      _onVisibilityChanged,
    );

    super.dispose();
  }

  void _onVisibilityChanged(bool visible) {
    _visible = visible;

    if (_visible) {
      // wait a second to see whether this tweet is still visible before
      // playing the gif
      Future<void>.delayed(const Duration(seconds: 1)).then((_) {
        if (mounted && _visible) {
          final model = context.read<HarpyVideoPlayerModel>();

          if (!model.initialized && !model.playing) {
            model.initialize();
            widget.onAutoplay?.call();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
