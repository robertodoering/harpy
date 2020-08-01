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
                  // todo: format created at string
                  '@${tweet.userData.screenName} \u00b7 ${tweet.createdAt}',
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
                // todo: format created at string
                '@${tweet.userData.screenName} \u00b7 '
                '${tweet.createdAt}',
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
  const TweetTranslation(this.tweet);

  final TweetData tweet;

  Widget _buildTranslatedText(ThemeData theme) {
    final String language = tweet.translation.language ?? 'Unknown';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // ensure full width column for the animated size animation
        const SizedBox(width: double.infinity),

        // 'translated from' original language text
        Text.rich(TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Translated from',
              style: theme.textTheme.bodyText1,
            ),
            TextSpan(text: ' $language'),
          ],
        )),

        // translated text
        TwitterText(
          tweet.translation.text,
          entities: tweet.entities,
          entityColor: theme.accentColor,
          urlToIgnore: tweet.quotedStatusUrl,
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
  const TweetActionRow(this.tweet);

  final TweetData tweet;

  Widget _buildTranslateButton(TweetBloc tweetBloc) {
    final bool enable = !tweetBloc.tweet.hasTranslation &&
        tweetBloc.state is! TranslatingTweetState;

    final Color color = tweetBloc.state is TranslatingTweetState ||
            tweetBloc.tweet.hasTranslation
        ? Colors.blue
        : null;

    return HarpyButton.flat(
      onTap: enable ? () => tweetBloc.add(const TranslateTweet()) : null,
      foregroundColor: color,
      icon: Icons.translate,
      iconSize: 20,
      padding: const EdgeInsets.all(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TweetBloc tweetBloc = TweetBloc.of(context);

    return BlocBuilder<TweetBloc, TweetState>(
      builder: (BuildContext context, TweetState state) => Row(
        children: <Widget>[
          HarpyButton.flat(
            onTap: () => tweetBloc.tweet.retweeted
                ? tweetBloc.add(const UnretweetTweet())
                : tweetBloc.add(const RetweetTweet()),
            icon: Icons.repeat,
            text: '${tweet.retweetCount}',
            foregroundColor: tweetBloc.tweet.retweeted ? Colors.green : null,
            iconSize: 20,
            padding: const EdgeInsets.all(8),
          ),
          const SizedBox(width: 8),
          FavoriteButton(
            favorited: tweetBloc.tweet.favorited,
            text: '${tweet.favoriteCount}',
            favorite: () => tweetBloc.add(const FavoriteTweet()),
            unfavorite: () => tweetBloc.add(const UnfavoriteTweet()),
          ),
          const Spacer(),
          if (tweetBloc.tweet.translatable) _buildTranslateButton(tweetBloc),
        ],
      ),
    );
  }
}
