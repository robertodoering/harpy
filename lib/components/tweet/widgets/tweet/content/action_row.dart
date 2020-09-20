import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/buttons/action_button.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/components/tweet/bloc/tweet_state.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/misc/harpy_navigator.dart';
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
    final RouteSettings route = ModalRoute.of(context).settings;

    return BlocBuilder<TweetBloc, TweetState>(
      builder: (BuildContext context, TweetState state) => Row(
        children: <Widget>[
          ActionButton(
            active: bloc.tweet.retweeted,
            activeIconColor: harpyTheme.retweetColor,
            value: tweet.retweetCount,
            activate: () => bloc.add(const RetweetTweet()),
            deactivate: () => bloc.add(const UnretweetTweet()),
            iconAnimationBuilder: (Animation<double> animation, Widget child) {
              return RotationTransition(
                turns: CurvedAnimation(
                  curve: Curves.easeOutBack,
                  parent: animation,
                ),
                child: child,
              );
            },
            iconBuilder: (
              BuildContext context,
              bool active,
              double size,
            ) {
              return Icon(Icons.repeat, size: size);
            },
          ),
          const SizedBox(width: 8),
          ActionButton(
            active: bloc.tweet.favorited,
            activeIconColor: harpyTheme.likeColor,
            value: tweet.favoriteCount,
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
          ),
          const SizedBox(width: 8),
          if (!tweet.currentReplyParent(route)) ...<Widget>[
            const SizedBox(width: 8),
            HarpyButton.flat(
              onTap: () => app<HarpyNavigator>().pushRepliesScreen(
                tweet: bloc.tweet,
              ),
              icon: Icons.chat_bubble_outline,
              iconSize: 20,
              padding: const EdgeInsets.all(8),
            ),
          ],
          const Spacer(),
          if (bloc.tweet.translatable || bloc.tweet.quoteTranslatable)
            _buildTranslateButton(bloc, harpyTheme),
        ],
      ),
    );
  }
}
