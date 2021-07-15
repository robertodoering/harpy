import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen();

  static const String route = 'language_settings';

  @override
  _LanguageSettingsScreenState createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  final LanguagePreferences? languagePreferences = app<LanguagePreferences>();

  Widget _buildTranslateSetting(Locale locale) {
    final translateValues = Map<String, String>.of(
      translateLanguages,
    );

    final systemDefault = mapLanguageCodeToTranslateLanguage(
      locale.languageCode,
    );

    translateValues[systemDefault] = '${translateValues[systemDefault]} '
        '(default)';

    final languageCode = languagePreferences!.hasSetTranslateLanguage
        ? languagePreferences!.translateLanguage
        : systemDefault;

    return RadioDialogTile<String>(
      leading: Icons.translate,
      title: 'Translate language',
      subtitle: translateValues[languageCode],
      description: 'Change the language used to translate tweets',
      value: languageCode,
      denseRadioTiles: true,
      titles: translateValues.values.toList(),
      values: translateLanguages.keys.toList(),
      onChanged: (value) {
        setState(() => languagePreferences!.translateLanguage = value!);
      },
    );
  }

  List<Widget> _buildSettings(Locale locale) {
    return [
      const ListTile(
        leading: Icon(Icons.translate),
        title: Text('App language'),
        subtitle: Text('coming soon!'),
        enabled: false,
      ),
      _buildTranslateSetting(locale),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return HarpyScaffold(
      title: 'language',
      buildSafeArea: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: _buildSettings(locale),
      ),
    );
  }
}
