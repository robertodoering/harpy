import 'package:flutter/material.dart';
import 'package:harpy/core/utils/string_utils.dart';

/// An [IconRow] to display an [Icon] next to some text.
class IconRow extends StatelessWidget {
  /// The [IconData] of the icon.
  final IconData icon;

  /// The [child] an either be a Widget or a String that will turn into a Widget
  /// and is displayed to the right of the [icon].
  final child;

  /// If [iconPadding] is not null the [icon] will be in the center of a
  /// [SizedBox] with a width of [iconPadding].
  final double iconPadding;

  /// The [TextStyle] of the [child] if it is a String.
  final TextStyle textStyle;

  const IconRow({
    @required this.icon,
    @required this.child,
    this.iconPadding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: iconPadding,
          child: Icon(icon, size: 18.0),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: child is Widget
              ? child
              : Text(
                  child,
                  style: textStyle ?? Theme.of(context).textTheme.display1,
                ),
        ),
      ],
    );
  }
}

/// A Widget to display the [followers] and [following] in a row.
class FollowersCount extends StatelessWidget {
  final int following;
  final int followers;

  const FollowersCount({
    this.following,
    this.followers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(formatNumber(following)),
        Text(" Following", style: Theme.of(context).textTheme.display1),
        SizedBox(width: 16),
        Text(formatNumber(followers)),
        Text(" Followers", style: Theme.of(context).textTheme.display1),
      ],
    );
  }
}
