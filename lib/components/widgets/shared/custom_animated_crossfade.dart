import 'package:flutter/material.dart';

/// Copied from [AnimatedCrossFade] without the [ClipRect] in the build method.
///
/// The [ClipRect] clips the shadow when using [Material] widgets with an
/// [AnimatedCrossFade].
///
/// See [AnimatedCrossFade] for more infos.
class CustomAnimatedCrossFade extends StatefulWidget {
  const CustomAnimatedCrossFade({
    @required this.firstChild,
    @required this.secondChild,
    @required this.crossFadeState,
    @required this.duration,
    Key key,
    this.firstCurve = Curves.linear,
    this.secondCurve = Curves.linear,
    this.sizeCurve = Curves.linear,
    this.alignment = Alignment.topCenter,
    this.reverseDuration,
    this.layoutBuilder = AnimatedCrossFade.defaultLayoutBuilder,
  })  : assert(firstChild != null),
        assert(secondChild != null),
        assert(firstCurve != null),
        assert(secondCurve != null),
        assert(sizeCurve != null),
        assert(alignment != null),
        assert(crossFadeState != null),
        assert(duration != null),
        assert(layoutBuilder != null),
        super(key: key);

  final Widget firstChild;
  final Widget secondChild;
  final CrossFadeState crossFadeState;
  final Duration duration;
  final Duration reverseDuration;
  final Curve firstCurve;
  final Curve secondCurve;
  final Curve sizeCurve;
  final AlignmentGeometry alignment;
  final AnimatedCrossFadeBuilder layoutBuilder;

  @override
  _CustomAnimatedCrossFadeState createState() =>
      _CustomAnimatedCrossFadeState();
}

class _CustomAnimatedCrossFadeState extends State<CustomAnimatedCrossFade>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _firstAnimation;
  Animation<double> _secondAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      vsync: this,
    );
    if (widget.crossFadeState == CrossFadeState.showSecond) {
      _controller.value = 1;
    }
    _firstAnimation = _initAnimation(widget.firstCurve, true);
    _secondAnimation = _initAnimation(widget.secondCurve, false);
    _controller.addStatusListener((status) {
      setState(() {
        // Trigger a rebuild because it depends on _isTransitioning, which
        // changes its value together with animation status.
      });
    });
  }

  Animation<double> _initAnimation(Curve curve, bool inverted) {
    Animation<double> result = _controller.drive(CurveTween(curve: curve));
    if (inverted) result = result.drive(Tween<double>(begin: 1, end: 0));
    return result;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomAnimatedCrossFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.reverseDuration != oldWidget.reverseDuration) {
      _controller.reverseDuration = widget.reverseDuration;
    }
    if (widget.firstCurve != oldWidget.firstCurve) {
      _firstAnimation = _initAnimation(widget.firstCurve, true);
    }
    if (widget.secondCurve != oldWidget.secondCurve) {
      _secondAnimation = _initAnimation(widget.secondCurve, false);
    }
    if (widget.crossFadeState != oldWidget.crossFadeState) {
      switch (widget.crossFadeState) {
        case CrossFadeState.showFirst:
          _controller.reverse();
          break;
        case CrossFadeState.showSecond:
          _controller.forward();
          break;
      }
    }
  }

  /// Whether we're in the middle of cross-fading this frame.
  bool get _isTransitioning =>
      _controller.status == AnimationStatus.forward ||
      _controller.status == AnimationStatus.reverse;

  @override
  Widget build(BuildContext context) {
    const Key kFirstChildKey =
        ValueKey<CrossFadeState>(CrossFadeState.showFirst);
    const Key kSecondChildKey =
        ValueKey<CrossFadeState>(CrossFadeState.showSecond);
    final bool transitioningForwards =
        _controller.status == AnimationStatus.completed ||
            _controller.status == AnimationStatus.forward;
    Key topKey;
    Widget topChild;
    Animation<double> topAnimation;
    Key bottomKey;
    Widget bottomChild;
    Animation<double> bottomAnimation;
    if (transitioningForwards) {
      topKey = kSecondChildKey;
      topChild = widget.secondChild;
      topAnimation = _secondAnimation;
      bottomKey = kFirstChildKey;
      bottomChild = widget.firstChild;
      bottomAnimation = _firstAnimation;
    } else {
      topKey = kFirstChildKey;
      topChild = widget.firstChild;
      topAnimation = _firstAnimation;
      bottomKey = kSecondChildKey;
      bottomChild = widget.secondChild;
      bottomAnimation = _secondAnimation;
    }

    bottomChild = TickerMode(
      key: bottomKey,
      enabled: _isTransitioning,
      child: ExcludeSemantics(
        // Always exclude the semantics of the widget that's fading out.
        excluding: true,
        child: FadeTransition(
          opacity: bottomAnimation,
          child: bottomChild,
        ),
      ),
    );
    topChild = TickerMode(
      key: topKey,
      enabled: true, // Top widget always has its animations enabled.
      child: ExcludeSemantics(
        // Always publish semantics for the widget that's fading in.
        excluding: false,
        child: FadeTransition(
          opacity: topAnimation,
          child: topChild,
        ),
      ),
    );
    return AnimatedSize(
      alignment: widget.alignment,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      curve: widget.sizeCurve,
      vsync: this,
      child: widget.layoutBuilder(topChild, topKey, bottomChild, bottomKey),
    );
  }
}
