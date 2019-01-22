import 'package:flutter/material.dart';

/// A [CustomExpansionTile] that expands or collapses to reveal or hide the
/// [child].
///
/// Used by [CollapsibleMedia].
///
/// Similar to [ExpansionTile].
class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    @required this.child,
    this.initiallyExpanded = true,
    this.onExpansionChanged,
  });

  final Widget child;
  final bool initiallyExpanded;
  final ValueChanged<bool> onExpansionChanged;

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
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
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _heightFactor = _controller.drive(_easeInTween);

    _isExpanded = widget.initiallyExpanded ?? true;

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;

      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged(_isExpanded);
      }

      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then((_) {
          if (mounted) {
            setState(() {
              // rebuild without child
            });
          }
        });
      }
    });
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
                child: Icon(
                  Icons.expand_more,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white54
                      : Colors.black54,
                ),
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
}
