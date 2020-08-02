import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/common/buttons/favorite_button.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/cached_circle_avatar.dart';
import 'package:harpy/components/common/twitter_text.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/components/tweet/bloc/tweet_state.dart';
import 'package:harpy/core/api/tweet_data.dart';
import 'package:harpy/misc/utils/string_utils.dart';
import 'package:intl/intl.dart';

/// Builds a row with the retweeter's display name indicating that a tweet is a
/// retweet.
class TweetRetweetedRow extends StatelessWidget {
  const TweetRetweetedRow(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        SizedBox(
          // same width as avatar with padding
          width: 40,
          child: Icon(Icons.repeat, size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${tweet.retweetUserName} retweeted',
            style: theme.textTheme.bodyText2.copyWith(
              color: theme.textTheme.bodyText2.color.withOpacity(.8),
            ),
          ),
        ),
      ],
    );
  }
}

/// Builds the tweet author's avatar, display name, username and the creation
/// date of the tweet.
class TweetAuthorRow extends StatelessWidget {
  const TweetAuthorRow(this.tweet);

  final TweetData tweet;

  void _onUserTap() {
    // todo: go to user screen
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: _onUserTap,
          child: CachedCircleAvatar(
            imageUrl: tweet.userData.profileImageUrlHttps,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _onUserTap,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        tweet.userData.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (tweet.userData.verified)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.verified_user, size: 16),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _onUserTap,
                child: Text(
                  '@${tweet.userData.screenName} \u00b7 '
                  '${tweetTimeDifference(tweet.createdAt)}',
                  style: theme.textTheme.bodyText1,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

/// Builds the author row for a quote similar to [TweetAuthorRow].
class TweetQuoteAuthorRow extends StatelessWidget {
  const TweetQuoteAuthorRow(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    const double fontSizeDelta = -2;

    return Row(
      children: <Widget>[
        CachedCircleAvatar(
          imageUrl: tweet.userData.profileImageUrlHttps,
          radius: 14,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      tweet.userData.name,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyText2.apply(
                        fontSizeDelta: fontSizeDelta,
                      ),
                    ),
                  ),
                  if (tweet.userData.verified)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.verified_user, size: 14),
                    ),
                ],
              ),
              Text(
                '@${tweet.userData.screenName} \u00b7 '
                '${tweetTimeDifference(tweet.createdAt)}',
                style: theme.textTheme.bodyText1.apply(
                  fontSizeDelta: fontSizeDelta,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    );
  }
}

/// Builds the translation for the tweet if it exists, or an empty [SizedBox] as
/// a placeholder if no translation exists.
///
/// Listens to the [TweetBloc] to build the translation text with an animation
/// when it exists.
class TweetTranslation extends StatelessWidget {
  const TweetTranslation(
    this.tweet, {
    this.fontSizeDelta = 0,
  });

  final TweetData tweet;

  /// An optional font size delta for the translation text.
  final double fontSizeDelta;

  Widget _buildTranslatedText(ThemeData theme) {
    final String language = tweet.translation.language ?? 'Unknown';

    final TextStyle bodyText1 = theme.textTheme.bodyText1.apply(
      fontSizeDelta: fontSizeDelta,
    );

    final TextStyle bodyText2 = theme.textTheme.bodyText2.apply(
      fontSizeDelta: fontSizeDelta,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // ensure full width column for the animated size animation
        const SizedBox(height: 8, width: double.infinity),

        // 'translated from' original language text
        Text.rich(
          TextSpan(
            children: <TextSpan>[
              const TextSpan(text: 'Translated from'),
              TextSpan(
                text: ' $language',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          style: bodyText1,
        ),

        // translated text
        TwitterText(
          tweet.translation.text,
          entities: tweet.entities,
          entityColor: theme.accentColor,
          urlToIgnore: tweet.quotedStatusUrl,
          style: bodyText2,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return CustomAnimatedSize(
      child: BlocBuilder<TweetBloc, TweetState>(
        builder: (BuildContext context, TweetState state) => AnimatedOpacity(
          opacity: tweet.hasTranslation ? 1 : 0,
          duration: kShortAnimationDuration,
          curve: Curves.easeOut,
          child: tweet.hasTranslation && !tweet.translation.unchanged
              ? _buildTranslatedText(theme)
              : const SizedBox(width: double.infinity),
        ),
      ),
    );
  }
}

/// Builds the buttons with actions for the [tweet].
class TweetActionRow extends StatelessWidget {
  TweetActionRow(this.tweet);

  final TweetData tweet;

  final NumberFormat _numberFormat = NumberFormat.compact();

  Widget _buildTranslateButton(TweetBloc bloc) {
    final bool enable =
        !bloc.tweet.hasTranslation && bloc.state is! TranslatingTweetState;

    final Color color =
        bloc.state is TranslatingTweetState || bloc.tweet.hasTranslation
            ? Colors.blue
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

    return BlocBuilder<TweetBloc, TweetState>(
      builder: (BuildContext context, TweetState state) => Row(
        children: <Widget>[
          HarpyButton.flat(
            onTap: () => bloc.tweet.retweeted
                ? bloc.add(const UnretweetTweet())
                : bloc.add(const RetweetTweet()),
            icon: Icons.repeat,
            text: _numberFormat.format(tweet.retweetCount),
            foregroundColor: bloc.tweet.retweeted ? Colors.green : null,
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
            _buildTranslateButton(bloc),
        ],
      ),
    );
  }
}
