import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class SensitiveMediaOverlay extends ConsumerStatefulWidget {
  const SensitiveMediaOverlay({
    required this.tweet,
    required this.child,
  });

  final LegacyTweetData tweet;
  final Widget child;

  @override
  ConsumerState<SensitiveMediaOverlay> createState() =>
      _SensitiveMediaOverlayState();
}

class _SensitiveMediaOverlayState extends ConsumerState<SensitiveMediaOverlay> {
  var _showOverlay = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = ref.watch(mediaPreferencesProvider);

    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: RbyAnimatedSwitcher(
            child: media.hidePossiblySensitive &&
                    widget.tweet.possiblySensitive &&
                    _showOverlay
                ? GestureDetector(
                    onTap: () => setState(() => _showOverlay = false),
                    child: ColoredBox(
                      color: theme.colorScheme.primary,
                      child: Center(
                        child: Icon(
                          CupertinoIcons.eye_slash_fill,
                          size: 48,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ),
      ],
    );
  }
}
