import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class VideoPlayerDoubleTapActions extends StatefulWidget {
  const VideoPlayerDoubleTapActions({
    required this.notifier,
    required this.data,
  });

  final VideoPlayerNotifier notifier;
  final VideoPlayerStateData data;

  @override
  _VideoPlayerDoubleTapActionsState createState() =>
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
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  widget.notifier.rewind();

                  setState(() {
                    _rewindIcon = AnimatedMediaThumbnailIcon(
                      key: UniqueKey(),
                      icon: const Icon(Icons.fast_rewind_rounded),
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
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  widget.notifier.forward();

                  setState(() {
                    _forwardIcon = AnimatedMediaThumbnailIcon(
                      key: UniqueKey(),
                      icon: const Icon(Icons.fast_forward_rounded),
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
