import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:harpy/components/shared/animations.dart';
import 'package:harpy/theme.dart';

final harpyTitleKey = new GlobalKey<_HarpyTitleState>();

/// An animated title that will fade in and fade out.
class HarpyTitle extends StatefulWidget {
  final bool skipIntroAnimation;

  /// The callback when the initial fade in animation finished.
  final VoidCallback finishCallback;

  HarpyTitle({
    Key key,
    this.skipIntroAnimation = false,
    this.finishCallback,
  }) : super(key: key);

  @override
  _HarpyTitleState createState() => _HarpyTitleState();

  /// Starts fading out the title.
  Future<void> fadeOut() async {
    await harpyTitleKey.currentState.fadeOut();
  }
}

class _HarpyTitleState extends State<HarpyTitle> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: lerpDouble(1.0, 0.33, _controller.value),
      child: Transform.translate(
        offset: Offset(
          0.0,
          lerpDouble(0.0, -100.0, _controller.value),
        ),
        child: Transform.scale(
          alignment: Alignment.topCenter,
          scale: lerpDouble(1.0, 0.8, _controller.value),
          child: SlideFadeInAnimation(
            duration: Duration(seconds: 2),
            delay: Duration(seconds: 0),
            offset: Offset(0.0, 100.0),
            skipIntroAnimation: widget.skipIntroAnimation,
            finishCallback: widget.finishCallback,
            child: Text(
              "Harpy",
              style: HarpyTheme.theme.textTheme.title,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fadeOut() async {
    await _controller.forward();
  }
}
