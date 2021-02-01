import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/action_button.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

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
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    return ActionButton(
      active: bloc.tweet.favorited,
      padding: padding,
      activeIconColor: harpyTheme.favoriteColor,
      activeTextStyle: TextStyle(
        color: harpyTheme.favoriteColor,
        fontWeight: FontWeight.bold,
      ),
      value: bloc.tweet.favoriteCount,
      activate: () => bloc.add(const FavoriteTweet()),
      deactivate: () => bloc.add(const UnfavoriteTweet()),
      iconSize: 22,
      iconBuilder: (
        BuildContext context,
        bool active,
        double size,
      ) {
        return Icon(
          active ? Icons.favorite : Icons.favorite_border,
          size: size,
        );
      },
    );
  }
}
