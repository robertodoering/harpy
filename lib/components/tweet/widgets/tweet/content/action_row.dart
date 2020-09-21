import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/buttons/favorite_button.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/buttons/retweet_button.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/components/tweet/bloc/tweet_state.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds the buttons with actions for the [tweet].
class TweetActionRow extends StatelessWidget {
  const TweetActionRow(this.tweet);

  final TweetData tweet;

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
      icon: const Icon(Icons.translate),
      iconSize: 20,
      padding: const EdgeInsets.all(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TweetBloc bloc = TweetBloc.of(context);
    final HarpyTheme harpyTheme = HarpyTheme.of(context);
    final RouteSettings route = ModalRoute.of(context).settings;

    return BlocBuilder<TweetBloc, TweetState>(
      builder: (BuildContext context, TweetState state) => Row(
        children: <Widget>[
          const RetweetButton(),
          const SizedBox(width: 8),
          const FavoriteButton(),
          const SizedBox(width: 8),
          if (!tweet.currentReplyParent(route)) ...<Widget>[
            const SizedBox(width: 8),
            HarpyButton.flat(
              onTap: () => app<HarpyNavigator>().pushRepliesScreen(
                tweet: tweet,
              ),
              icon: const Icon(Icons.chat_bubble_outline),
              iconSize: 20,
              padding: const EdgeInsets.all(8),
            ),
          ],
          const Spacer(),
          if (tweet.translatable || tweet.quoteTranslatable)
            _buildTranslateButton(bloc, harpyTheme),
        ],
      ),
    );
  }
}
