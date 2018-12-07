import 'package:flutter/material.dart';

/// A [MediaExpansion] that expands or collapses to reveal or hide the [child].
///
/// Similar to [ExpansionTile].
class MediaExpansion extends StatefulWidget {
  final Widget child;
  final bool initiallyExpanded;

  const MediaExpansion({
    @required this.child,
    this.initiallyExpanded = true,
  });

  @override
  _MediaExpansionState createState() => _MediaExpansionState();
}

class _MediaExpansionState extends State<MediaExpansion>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  AnimationController _controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _heightFactor = _controller.drive(_easeInTween);

    _isExpanded = widget.initiallyExpanded;

    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;

      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((_) {
          if (!mounted) return;
          setState(() {
            // rebuild without child
          });
        });
      }
    });
  }

  Widget _buildChild(BuildContext context, Widget child) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 32.0,
          child: InkWell(
            onTap: _handleTap,
            child: Center(
              child: RotationTransition(
                turns: _iconTurns,
                child: const Icon(Icons.expand_more),
              ),
            ),
          ),
        ),
        ClipRect(
          child: Align(
            heightFactor: _heightFactor.value,
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChild,
      child: closed ? null : widget.child,
    );
  }
}
