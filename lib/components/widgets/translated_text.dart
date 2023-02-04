import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class TranslatedText extends ConsumerWidget {
  const TranslatedText(
    this.text, {
    this.language,
    this.textDirection,
    this.entities,
    this.urlToIgnore,
    this.fontSizeDelta = 0,
  });

  final String text;
  final String? language;
  final TextDirection? textDirection;
  final EntitiesData? entities;
  final String? urlToIgnore;
  final double fontSizeDelta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final translateLanguage =
        ref.watch(languagePreferencesProvider).activeTranslateLanguage(locale);

    final textDirection = rtlLanguageCodes.contains(translateLanguage)
        ? TextDirection.rtl
        : TextDirection.ltr;

    final bodyText1 = theme.textTheme.bodyLarge!.apply(
      fontSizeDelta: fontSizeDelta,
    );

    final bodyText2 = theme.textTheme.bodyMedium!.apply(
      fontSizeDelta: fontSizeDelta,
    );

    return Directionality(
      textDirection: textDirection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 'translated from' original language text
          Text.rich(
            TextSpan(
              children: [
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
      ),
    );
  }
}
