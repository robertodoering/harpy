import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/buttons/favorite_button.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/components/tweet/bloc/tweet_state.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:intl/intl.dart';

/// Builds the buttons with actions for the [tweet].
class TweetActionRow extends StatelessWidget {
  TweetActionRow(this.tweet);

  final TweetData tweet;

  final NumberFormat _numberFormat = NumberFormat.compact();

  Widget _buildTranslateButton(TweetBloc bloc, HarpyTheme harpyTheme) {
    final bool enable =
        !bloc.tweet.hasTranslation && bloc.state is! TranslatingTweetState;

    final Color color =
        bloc.state is TranslatingTweetState || bloc.tweet.hasTranslation
            ? harpyTheme.translateColor
            : null;

    return HarpyButton.flat(
      onTap: enable ? () => bloc.add(const TranslateTweet()) : null,
      foregroundColor: color,
      icon: Icons.translate,
      iconSize: 20,
      padding: const EdgeInsets.all(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TweetBloc bloc = TweetBloc.of(context);
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    return BlocBuilder<TweetBloc, TweetState>(
      builder: (BuildContext context, TweetState state) => Row(
        children: <Widget>[
          HarpyButton.flat(
            onTap: () => bloc.tweet.retweeted
                ? bloc.add(const UnretweetTweet())
                : bloc.add(const RetweetTweet()),
            icon: Icons.repeat,
            text: _numberFormat.format(tweet.retweetCount),
            foregroundColor:
                bloc.tweet.retweeted ? harpyTheme.retweetColor : null,
            iconSize: 20,
            padding: const EdgeInsets.all(8),
          ),
          const SizedBox(width: 8),
          FavoriteButton(
            favorited: bloc.tweet.favorited,
            text: _numberFormat.format(tweet.favoriteCount),
            favorite: () => bloc.add(const FavoriteTweet()),
            unfavorite: () => bloc.add(const UnfavoriteTweet()),
          ),
          const Spacer(),
          if (bloc.tweet.translatable || bloc.tweet.quoteTranslatable)
            _buildTranslateButton(bloc, harpyTheme),
        ],
      ),
    );
  }
}
