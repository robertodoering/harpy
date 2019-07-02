import 'package:flutter/material.dart';
import 'package:harpy/core/utils/string_utils.dart';

/// An [IconRow] to display an [Icon] next to some text.
class IconRow extends StatelessWidget {
  const IconRow({
    @required this.icon,
    @required this.child,
    this.iconPadding,
  });

  /// The [IconData] of the icon.
  final IconData icon;

  /// The [child] an either be a Widget or a String that will turn into a text
  /// widget and is displayed to the right of the [icon].
  final dynamic child;

  /// If [iconPadding] is not null the [icon] will be in the center of a
  /// [SizedBox] with a width of [iconPadding].
  final double iconPadding;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.body1;

    return Row(
      children: <Widget>[
        SizedBox(
          width: iconPadding,
          child: Icon(icon, size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: child is Widget
              ? child
              : Text(
                  child,
                  style: textStyle.copyWith(
                    color: textStyle.color.withOpacity(0.8),
                  ),
                ),
        ),
      ],
    );
  }
}

/// A Widget to display the [followers] and [following] in a row.
class FollowersCount extends StatelessWidget {
  const FollowersCount({
    this.following,
    this.followers,
  });

  final int following;
  final int followers;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: formatNumber(following)),
              const TextSpan(text: " Following"),
            ]),
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: formatNumber(followers)),
              const TextSpan(text: " Followers"),
            ]),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
