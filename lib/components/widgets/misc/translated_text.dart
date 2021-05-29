import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

/// Builds text for translated [TwitterText] with the original [language] above
/// the [text].
class TranslatedText extends StatelessWidget {
  const TranslatedText(
    this.text, {
    this.language,
    this.entities,
    this.urlToIgnore,
    this.fontSizeDelta = 0,
  });

  final String text;
  final String? language;
  final EntitiesData? entities;
  final String? urlToIgnore;
  final double fontSizeDelta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bodyText1 = theme.textTheme.bodyText1!.apply(
      fontSizeDelta: fontSizeDelta,
    );

    final bodyText2 = theme.textTheme.bodyText2!.apply(
      fontSizeDelta: fontSizeDelta,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // 'translated from' original language text
        Text.rich(
          TextSpan(
            children: <TextSpan>[
              const TextSpan(text: 'translated from'),
              TextSpan(
                text: ' ${language ?? 'unknown'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          style: bodyText1,
        ),

        // translated text
        TwitterText(
          text,
          entities: entities,
          urlToIgnore: urlToIgnore,
          style: bodyText2,
        ),
      ],
    );
  }
}
