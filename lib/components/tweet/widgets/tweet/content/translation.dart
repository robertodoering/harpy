import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/common/misc/translated_text.dart';
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

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedSize(
      child: BlocBuilder<TweetBloc, TweetState>(
        builder: (BuildContext context, TweetState state) => AnimatedOpacity(
          opacity: tweet.hasTranslation ? 1 : 0,
          duration: kShortAnimationDuration,
          curve: Curves.easeOut,
          child: tweet.hasTranslation && !tweet.translation.unchanged
              ? TranslatedText(
                  tweet.translation.text,
                  language: tweet.translation.language,
                  entities: tweet.entities,
                  urlToIgnore: tweet.quotedStatusUrl,
                  fontSizeDelta: fontSizeDelta,
                )
              : const SizedBox(width: double.infinity),
        ),
      ),
    );
  }
}
