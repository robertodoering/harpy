import 'package:flutter/material.dart';
import 'package:harpy/core/core.dart';

/// The padding value based on the [LayoutPreferences].
double get defaultPaddingValue => app<LayoutPreferences>().compactMode ? 8 : 16;
double get defaultSmallPaddingValue => defaultPaddingValue / 2;

/// A horizontal spacer widget based on the [LayoutPreferences].
Widget get defaultHorizontalSpacer => SizedBox(width: defaultPaddingValue);
Widget get defaultSmallHorizontalSpacer =>
    SizedBox(width: defaultSmallPaddingValue);

/// A vertical spacer widget based on the [LayoutPreferences].
Widget get defaultVerticalSpacer => SizedBox(height: defaultPaddingValue);
Widget get defaultSmallVerticalSpacer =>
    SizedBox(height: defaultSmallPaddingValue);

/// The [EdgeInsets] that uses the [LayoutPreferences] to create the insets.
class DefaultEdgeInsets extends EdgeInsets {
  DefaultEdgeInsets.all() : super.all(defaultPaddingValue);

  DefaultEdgeInsets.only({
    bool left = false,
    bool right = false,
    bool top = false,
    bool bottom = false,
  }) : super.only(
          left: left ? defaultPaddingValue : 0,
          right: right ? defaultPaddingValue : 0,
          top: top ? defaultPaddingValue : 0,
          bottom: bottom ? defaultPaddingValue : 0,
        );

  DefaultEdgeInsets.symmetric({
    bool horizontal = false,
    bool vertical = false,
  }) : super.symmetric(
          horizontal: horizontal ? defaultPaddingValue : 0,
          vertical: vertical ? defaultPaddingValue : 0,
        );
}
