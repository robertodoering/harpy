import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class TranslateLanguagesDialogTile extends ConsumerWidget {
  const TranslateLanguagesDialogTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final language = ref.watch(languagePreferencesProvider);

    final locale = Localizations.localeOf(context);
    final groupValue = language.activeTranslateLanguage(locale);
    final name = kTranslateLanguages[groupValue];

    return RbyListTile(
      leading: const Icon(Icons.translate),
      title: const Text('translate language'),
      subtitle: name != null ? Text(name) : null,
      multilineTitle: true,
      borderRadius: theme.shape.borderRadius,
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => const _TranslateLanguageDialog(),
      ),
    );
  }
}

class _TranslateLanguageDialog extends ConsumerStatefulWidget {
  const _TranslateLanguageDialog();

  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends ConsumerState<_TranslateLanguageDialog> {
  String _filter = '';

  Map<String, Widget> _entries(Locale locale) {
    final systemLanguage =
        kTranslateLanguages[translateLanguageFromLocale(locale) ?? 'en'];

    return Map.fromEntries(
      [
        MapEntry('', 'System ($systemLanguage)'),
        ...kTranslateLanguages.entries,
      ].where(
        (entry) =>
            entry.key.toLowerCase().contains(_filter.toLowerCase()) ||
            entry.value.toLowerCase().contains(_filter.toLowerCase()),
      ),
    ).map((key, value) => MapEntry(key, Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final language = ref.watch(languagePreferencesProvider);
    final languageNotifier = ref.watch(languagePreferencesProvider.notifier);

    final locale = Localizations.localeOf(context);
    final groupValue = language.translateLanguage;

    return RbyDialog(
      title: const Text('change the language used to translate tweets'),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      stickyContent: Padding(
        padding: theme.spacing.edgeInsets,
        child: TextField(
          decoration: InputDecoration(
            hintText: kTranslateLanguages[groupValue],
          ),
          onChanged: (value) => setState(() => _filter = value),
        ),
      ),
      content: Column(
        children: [
          for (final entry in _entries(locale).entries)
            RbyRadioTile<String>(
              title: entry.value,
              value: entry.key,
              groupValue: groupValue,
              leadingPadding: theme.spacing.edgeInsets / 4,
              contentPadding: theme.spacing.edgeInsets / 4,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
                if (value != groupValue) {
                  languageNotifier.setTranslateLanguage(value);
                }
              },
            ),
        ],
      ),
    );
  }
}
