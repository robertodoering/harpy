import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/common/twitter_text.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_state.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

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
                style: const TextStyle(fontWeight: FontWeight.bold),
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
