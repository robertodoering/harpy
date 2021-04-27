import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// A tab for a [HarpySliverTabView].
class HarpyTab extends StatefulWidget {
  const HarpyTab({
    @required this.icon,
    this.text,
    this.cardColor,
  });

  final Widget icon;
  final Widget text;

  final Color cardColor;

  /// The height of a tab.
  static const double height = tabPadding * 2 + tabIconSize;

  static const double tabPadding = 16;
  static const double tabIconSize = 20;

  @override
  _HarpyTabState createState() => _HarpyTabState();
}

class _HarpyTabState extends State<HarpyTab>
    with SingleTickerProviderStateMixin<HarpyTab> {
  /// Controls how much the tab's associated content is in view.
  ///
  /// 1: Tab content is fully in view and tab should appear selected.
  /// 0: Tab content is not visible.
  AnimationController _animationController;

  Animation<Color> _colorAnimation;
  Animation<double> _opacityAnimation;
  Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this)
      ..addListener(() => setState(() {}));

    _opacityAnimation = Tween<double>(
      begin: 1,
      end: .5,
    ).animate(_animationController);

    _textOpacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, .5),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _animationController.value = HarpyTabScope.of(context)?.animationValue;

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

  Widget _buildText() {
    return Opacity(
      opacity: _textOpacityAnimation.value,
      child: Align(
        widthFactor: 1 - _animationController.value,
        alignment: Alignment.centerRight,
        child: Row(
          children: <Widget>[
            defaultSmallHorizontalSpacer,
            widget.text,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final IconThemeData iconTheme = IconTheme.of(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, Widget child) => Opacity(
        opacity: _opacityAnimation.value,
        child: Card(
          color: widget.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(HarpyTab.tabPadding),
            child: IconTheme(
              data: iconTheme.copyWith(
                color: _colorAnimation.value,
                size: HarpyTab.tabIconSize,
              ),
              child: DefaultTextStyle(
                style: theme.textTheme.subtitle1.copyWith(
                  color: _colorAnimation.value,
                ),
                child: SizedBox(
                  height: HarpyTab.tabIconSize,
                  child: Row(
                    children: <Widget>[
                      widget.icon,
                      if (widget.text != null) _buildText(),
                    ],
                  ),
                ),
              ),
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
