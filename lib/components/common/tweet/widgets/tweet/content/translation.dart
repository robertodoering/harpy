import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds the translation for the tweet if it exists, or an empty [SizedBox] as
/// a placeholder if no translation exists.
///
/// Listens to the [TweetBloc] to build the translation text with an animation
/// when it exists.
class TweetTranslation extends StatelessWidget {
  const TweetTranslation(
    this.tweet, {
    this.padding = EdgeInsets.zero,
    this.fontSizeDelta = 0,
  });

  final TweetData tweet;
  final EdgeInsets padding;

  /// An optional font size delta for the translation text.
  final double fontSizeDelta;

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedSize(
      child: AnimatedOpacity(
        opacity: tweet.hasTranslation ? 1 : 0,
        duration: kShortAnimationDuration,
        curve: Curves.easeOut,
        child: tweet.hasTranslation && !tweet.translation!.unchanged
            ? AnimatedPadding(
                duration: kLongAnimationDuration,
                padding: padding,
                child: TranslatedText(
                  tweet.translation!.text!,
                  language: tweet.translation!.language,
                  entities: tweet.entities,
                  urlToIgnore: tweet.quoteUrl,
                  fontSizeDelta: fontSizeDelta,
                ),
              )
            : const SizedBox(width: double.infinity),
      ),
    );
  }
}
