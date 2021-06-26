import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/preferences/layout_preferences.dart';
import 'package:harpy/core/services/service_locator.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// The favorite button for the [TweetCardActionsRow].
class FavoriteButton extends StatelessWidget {
  const FavoriteButton(
    this.bloc, {
    this.padding = const EdgeInsets.all(8),
    this.iconSize = 22,
    this.sizeDelta = 0,
  });

  final TweetBloc bloc;
  final EdgeInsets padding;
  final double iconSize;
  final double sizeDelta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final harpyTheme = HarpyTheme.of(context);

    final fontSizeDelta = app<LayoutPreferences>().fontSizeDelta;

    return ActionButton(
      active: bloc.tweet.favorited,
      padding: padding,
      activeIconColor: harpyTheme.favoriteColor,
      activeTextStyle: theme.textTheme.button!
          .copyWith(
            color: harpyTheme.favoriteColor,
            fontWeight: FontWeight.bold,
          )
          .apply(fontSizeDelta: fontSizeDelta + sizeDelta),
      inactiveTextStyle: theme.textTheme.button!
          .copyWith(color: theme.textTheme.bodyText2!.color)
          .apply(fontSizeDelta: fontSizeDelta + sizeDelta),
      value: bloc.tweet.favoriteCount,
      activate: bloc.onFavorite,
      deactivate: bloc.onUnfavorite,
      iconSize: iconSize + fontSizeDelta + sizeDelta,
      iconBuilder: (_, active, size) => Icon(
        active ? CupertinoIcons.heart_solid : CupertinoIcons.heart,
        size: size,
      ),
    );
  }
}
