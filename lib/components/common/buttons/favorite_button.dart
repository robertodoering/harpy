import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/action_button.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// The favorite button for the [TweetActionRow].
class FavoriteButton extends StatelessWidget {
  const FavoriteButton();

  @override
  Widget build(BuildContext context) {
    final TweetBloc bloc = TweetBloc.of(context);
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    return ActionButton(
      active: bloc.tweet.favorited,
      activeIconColor: Colors.pinkAccent,
      activeTextColor: Colors.pinkAccent,
      value: bloc.tweet.favoriteCount,
      activate: () => bloc.add(const FavoriteTweet()),
      deactivate: () => bloc.add(const UnfavoriteTweet()),
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
