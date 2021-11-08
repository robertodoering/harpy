import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// The favorite button for the [TweetCardActionsRow].
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    this.padding = const EdgeInsets.all(8),
    this.iconSize = 22,
    this.sizeDelta = 0,
  });

  final EdgeInsets padding;
  final double iconSize;
  final double sizeDelta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final harpyTheme = context.watch<HarpyTheme>();

    final bloc = context.watch<TweetBloc>();

    return ActionButton(
      active: bloc.state.favorited,
      padding: padding,
      activeIconColor: harpyTheme.favoriteColor,
      activeTextStyle: theme.textTheme.button!
          .copyWith(
            color: harpyTheme.favoriteColor,
            fontWeight: FontWeight.bold,
          )
          .apply(fontSizeDelta: sizeDelta),
      inactiveTextStyle: theme.textTheme.button!
          .copyWith(color: theme.textTheme.bodyText2!.color)
          .apply(fontSizeDelta: sizeDelta),
      value: bloc.tweet.favoriteCount,
      activate: bloc.onFavorite,
      deactivate: bloc.onUnfavorite,
      iconSize: iconSize,
      iconBuilder: (_, active, size) => Icon(
        active ? CupertinoIcons.heart_solid : CupertinoIcons.heart,
        size: size,
      ),
    );
  }
}
