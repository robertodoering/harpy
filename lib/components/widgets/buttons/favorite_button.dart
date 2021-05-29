import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// The favorite button for the [TweetActionRow].
class FavoriteButton extends StatelessWidget {
  const FavoriteButton(
    this.bloc, {
    this.padding = const EdgeInsets.all(8),
  });

  final TweetBloc bloc;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final harpyTheme = HarpyTheme.of(context);

    return ActionButton(
      active: bloc.state.tweet.favorited,
      padding: padding,
      activeIconColor: harpyTheme.favoriteColor,
      activeTextStyle: TextStyle(
        color: harpyTheme.favoriteColor,
        fontWeight: FontWeight.bold,
      ),
      value: bloc.state.tweet.favoriteCount,
      activate: bloc.onFavorite,
      deactivate: bloc.onUnfavorite,
      iconSize: 22,
      iconBuilder: (_, active, size) => Icon(
        active ? CupertinoIcons.heart_solid : CupertinoIcons.heart,
        size: size,
      ),
    );
  }
}
