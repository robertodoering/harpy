import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class TranslateLanguagesDialogTile extends ConsumerWidget {
  const TranslateLanguagesDialogTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);
    final language = ref.watch(languagePreferencesProvider);

    final locale = Localizations.localeOf(context);
    final groupValue = language.activeTranslateLanguage(locale);
    final name = kTranslateLanguages[groupValue];

    return HarpyListTile(
      leading: const Icon(Icons.translate),
      title: const Text('translate language'),
      subtitle: name != null ? Text(name) : null,
      multilineTitle: true,
      borderRadius: harpyTheme.borderRadius,
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

  Map<String, Widget> get _entries => Map.fromEntries(
        kTranslateLanguages.entries.where(
          (entry) =>
              entry.key.toLowerCase().contains(_filter.toLowerCase()) ||
              entry.value.toLowerCase().contains(_filter.toLowerCase()),
        ),
      ).map((key, value) => MapEntry(key, Text(value)));

  @override
  Widget build(BuildContext context) {
    final display = ref.watch(displayPreferencesProvider);
    final language = ref.watch(languagePreferencesProvider);
    final languageNotifier = ref.watch(languagePreferencesProvider.notifier);

    final locale = Localizations.localeOf(context);
    final groupValue = language.translateLanguage;

    final systemLanguage =
        kTranslateLanguages[translateLanguageFromLocale(locale) ?? 'en'];

    return HarpyDialog(
      title: const Text('change the language used to translate tweets'),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      stickyContent: Padding(
        padding: display.edgeInsets,
        child: TextField(
          decoration: InputDecoration(
            hintText: kTranslateLanguages[groupValue],
          ),
          onChanged: (value) => setState(() => _filter = value),
        ),
      ),
      content: Column(
        children: [
          HarpyRadioTile<String>(
            title: Text('System ($systemLanguage)'),
            value: '',
            groupValue: groupValue,
            leadingPadding: display.edgeInsets / 4,
            contentPadding: display.edgeInsets / 4,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
              if (value != groupValue) {
                languageNotifier.setTranslateLanguage(value);
              }
            },
          ),
          for (final entry in _entries.entries)
            HarpyRadioTile<String>(
              title: entry.value,
              value: entry.key,
              groupValue: groupValue,
              leadingPadding: display.edgeInsets / 4,
              contentPadding: display.edgeInsets / 4,
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
