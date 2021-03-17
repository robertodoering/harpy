import 'package:flutter/material.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

/// A tab for a [HarpySliverTabView].
class HarpyTab extends StatefulWidget {
  const HarpyTab({
    this.icon,
    this.text,
  }) : assert(icon != null || text != null);

  final Widget icon;
  final Widget text;

  @override
  _HarpyTabState createState() => _HarpyTabState();
}

class _HarpyTabState extends State<HarpyTab>
    with SingleTickerProviderStateMixin<HarpyTab> {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _animationController.value = HarpyTabScope.of(context).animationValue;

    final ThemeData theme = Theme.of(context);

    _colorAnimation = ColorTween(
      begin: theme.accentColor,
      end: theme.textTheme.subtitle1.color,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final IconThemeData iconTheme = IconTheme.of(context);

    return Card(
      child: Container(
        padding: DefaultEdgeInsets.all(),
        child: IconTheme(
          data: iconTheme.copyWith(color: _colorAnimation.value),
          child: DefaultTextStyle(
            style: theme.textTheme.subtitle1.copyWith(
              color: _colorAnimation.value,
            ),
            child: Row(
              children: <Widget>[
                if (widget.icon != null) widget.icon,
                if (widget.icon != null && widget.text != null)
                  defaultSmallHorizontalSpacer,
                if (widget.text != null) widget.text,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Exposes values for the [HarpyTab].
class HarpyTabScope extends InheritedWidget {
  const HarpyTabScope({
    Key key,
    @required this.index,
    @required this.animationValue,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  final int index;

  /// A value between 0 and 1 that corresponds to how much the tab content
  /// for [index] is in view.
  final double animationValue;

  static HarpyTabScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HarpyTabScope>();
  }

  @override
  bool updateShouldNotify(HarpyTabScope oldWidget) {
    return oldWidget.index != index ||
        oldWidget.animationValue != animationValue;
  }
}
