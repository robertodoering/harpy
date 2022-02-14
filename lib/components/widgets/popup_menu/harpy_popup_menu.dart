import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const _kMenuDuration = Duration(milliseconds: 300);
const _kMenuCloseIntervalEnd = 2.0 / 3.0;
const _kMenuMaxWidth = 5.0 * _kMenuWidthStep;
const _kMenuMinWidth = 2.0 * _kMenuWidthStep;
const _kMenuWidthStep = 56.0;
const _kMenuScreenPadding = 8.0;

// Copied and modified from `popup_menu.dart` in `flutter/material`.
//
// Differences from the original implementations include:
// * Vertical menu padding is set to 0 (instead of 8)
// * The menu clips the content
//   This prevents menu entries to draw outside the corners if the menu shape
//   has a border radius > 8

Future<T?> showHarpyMenu<T>({
  required BuildContext context,
  required RelativeRect position,
  required List<PopupMenuEntry<T>> items,
  T? initialValue,
  double? elevation,
  String? semanticLabel,
  ShapeBorder? shape,
  Color? color,
  bool useRootNavigator = false,
}) {
  assert(items.isNotEmpty);

  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);

  return navigator.push(
    _PopupMenuRoute<T>(
      position: position,
      items: items,
      initialValue: initialValue,
      elevation: elevation,
      semanticLabel: semanticLabel,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      shape: shape,
      color: color,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
    ),
  );
}

class _PopupMenu<T> extends StatelessWidget {
  const _PopupMenu({
    required this.route,
    required this.semanticLabel,
  });

  final _PopupMenuRoute<T> route;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final unit = 1.0 / (route.items.length + 1.5);
    final children = <Widget>[];
    final popupMenuTheme = PopupMenuTheme.of(context);

    for (var i = 0; i < route.items.length; i += 1) {
      final start = (i + 1) * unit;
      final end = (start + 1.5 * unit).clamp(0.0, 1.0);
      final opacity = CurvedAnimation(
        parent: route.animation!,
        curve: Interval(start, end),
      );

      Widget item = route.items[i];

      if (route.initialValue != null &&
          route.items[i].represents(route.initialValue)) {
        item = Container(
          color: Theme.of(context).highlightColor,
          child: item,
        );
      }

      children.add(
        _MenuItem(
          onLayout: (size) {
            route.itemSizes[i] = size;
          },
          child: FadeTransition(
            opacity: opacity,
            child: item,
          ),
        ),
      );
    }

    final opacity = CurveTween(curve: const Interval(0, 1.0 / 3.0));
    final width = CurveTween(curve: Interval(0, unit));
    final height = CurveTween(curve: Interval(0, unit * route.items.length));

    final child = ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: _kMenuMinWidth,
        maxWidth: _kMenuMaxWidth,
      ),
      child: IntrinsicWidth(
        stepWidth: _kMenuWidthStep,
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: semanticLabel,
          child: SingleChildScrollView(
            child: ListBody(children: children),
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: route.animation!,
      builder: (context, child) => FadeTransition(
        opacity: opacity.animate(route.animation!),
        child: Material(
          shape: route.shape ?? popupMenuTheme.shape,
          color: route.color ?? popupMenuTheme.color,
          type: MaterialType.card,
          elevation: route.elevation ?? popupMenuTheme.elevation ?? 8.0,
          clipBehavior: Clip.antiAlias,
          child: Align(
            alignment: AlignmentDirectional.topEnd,
            widthFactor: width.evaluate(route.animation!),
            heightFactor: height.evaluate(route.animation!),
            child: child,
          ),
        ),
      ),
      child: child,
    );
  }
}

class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(
    this.position,
    this.itemSizes,
    this.selectedItemIndex,
    this.textDirection,
    this.padding,
  );

  final RelativeRect position;

  List<Size?> itemSizes;

  final int? selectedItemIndex;

  final TextDirection textDirection;

  EdgeInsets padding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(_kMenuScreenPadding) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final buttonHeight = size.height - position.top - position.bottom;

    var y = position.top;
    if (selectedItemIndex != null) {
      var selectedItemOffset = 0.0;

      for (var index = 0; index < selectedItemIndex!; index += 1)
        selectedItemOffset += itemSizes[index]!.height;

      selectedItemOffset += itemSizes[selectedItemIndex!]!.height / 2;
      y = y + buttonHeight / 2.0 - selectedItemOffset;
    }

    double x;
    if (position.left > position.right)
      x = size.width - position.right - childSize.width;
    else if (position.left < position.right)
      x = position.left;
    else
      switch (textDirection) {
        case TextDirection.rtl:
          x = size.width - position.right - childSize.width;
          break;
        case TextDirection.ltr:
          x = position.left;
          break;
      }

    if (x < _kMenuScreenPadding + padding.left)
      x = _kMenuScreenPadding + padding.left;
    else if (x + childSize.width >
        size.width - _kMenuScreenPadding - padding.right)
      x = size.width - childSize.width - _kMenuScreenPadding - padding.right;
    if (y < _kMenuScreenPadding + padding.top)
      y = _kMenuScreenPadding + padding.top;
    else if (y + childSize.height >
        size.height - _kMenuScreenPadding - padding.bottom)
      y = size.height - padding.bottom - _kMenuScreenPadding - childSize.height;

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    assert(itemSizes.length == oldDelegate.itemSizes.length);

    return position != oldDelegate.position ||
        selectedItemIndex != oldDelegate.selectedItemIndex ||
        textDirection != oldDelegate.textDirection ||
        !listEquals(itemSizes, oldDelegate.itemSizes) ||
        padding != oldDelegate.padding;
  }
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  _PopupMenuRoute({
    required this.position,
    required this.items,
    required this.barrierLabel,
    required this.capturedThemes,
    this.initialValue,
    this.elevation,
    this.semanticLabel,
    this.shape,
    this.color,
  }) : itemSizes = List<Size?>.filled(items.length, null);

  final RelativeRect position;
  final List<PopupMenuEntry<T>> items;
  final List<Size?> itemSizes;
  final T? initialValue;
  final double? elevation;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final Color? color;
  final CapturedThemes capturedThemes;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0, _kMenuCloseIntervalEnd),
    );
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    int? selectedItemIndex;

    if (initialValue != null) {
      for (var index = 0;
          selectedItemIndex == null && index < items.length;
          index += 1) {
        if (items[index].represents(initialValue)) selectedItemIndex = index;
      }
    }

    final menu = _PopupMenu<T>(route: this, semanticLabel: semanticLabel);
    final mediaQuery = MediaQuery.of(context);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (context) => CustomSingleChildLayout(
          delegate: _PopupMenuRouteLayout(
            position,
            itemSizes,
            selectedItemIndex,
            Directionality.of(context),
            mediaQuery.padding,
          ),
          child: capturedThemes.wrap(menu),
        ),
      ),
    );
  }
}

class _MenuItem extends SingleChildRenderObjectWidget {
  const _MenuItem({
    required this.onLayout,
    required Widget? child,
  }) : super(child: child);

  final ValueChanged<Size> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(onLayout);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMenuItem renderObject,
  ) {
    renderObject.onLayout = onLayout;
  }
}

class _RenderMenuItem extends RenderShiftedBox {
  _RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      child == null ? Size.zero : child!.getDryLayout(constraints);

  @override
  void performLayout() {
    if (child == null) {
      size = Size.zero;
    } else {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
      (child!.parentData! as BoxParentData).offset = Offset.zero;
    }
    onLayout(size);
  }
}
