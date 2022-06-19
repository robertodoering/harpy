import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';

class VideoPlayerDoubleTapActions extends StatefulWidget {
  const VideoPlayerDoubleTapActions({
    required this.notifier,
    required this.data,
    this.compact = false,
  });

  final VideoPlayerNotifier notifier;
  final VideoPlayerStateData data;
  final bool compact;

  @override
  State<VideoPlayerDoubleTapActions> createState() =>
      _VideoPlayerDoubleTapActionsState();
}

class _VideoPlayerDoubleTapActionsState
    extends State<VideoPlayerDoubleTapActions> {
  Widget? _rewindIcon;
  Widget? _forwardIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  HapticFeedback.lightImpact();
                  widget.notifier.rewind();

                  setState(() {
                    _rewindIcon = AnimatedMediaThumbnailIcon(
                      key: UniqueKey(),
                      icon: const Icon(Icons.fast_rewind_rounded),
                      compact: widget.compact,
                    );
                  });
                },
              ),
              if (_rewindIcon != null) _rewindIcon!,
            ],
          ),
        ),
        const Spacer(),
        Expanded(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  HapticFeedback.lightImpact();
                  widget.notifier.forward();

                  setState(() {
                    _forwardIcon = AnimatedMediaThumbnailIcon(
                      key: UniqueKey(),
                      icon: const Icon(Icons.fast_forward_rounded),
                      compact: widget.compact,
                    );
                  });
                },
              ),
              if (_forwardIcon != null) _forwardIcon!,
            ],
          ),
        ),
      ],
    );
  }
}
