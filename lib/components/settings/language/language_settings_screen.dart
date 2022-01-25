import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen();

  static const route = 'language_settings';

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return HarpyScaffold(
      body: CustomScrollView(
        slivers: [
          const HarpySliverAppBar(
            title: 'language settings',
            floating: true,
          ),
          SliverPadding(
            padding: config.edgeInsets,
            sliver: const _GeneralSettingsList(),
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}

class _GeneralSettingsList extends StatefulWidget {
  const _GeneralSettingsList();

  @override
  _GeneralSettingsListState createState() => _GeneralSettingsListState();
}

class _GeneralSettingsListState extends State<_GeneralSettingsList> {
  @override
  Widget build(BuildContext context) {
    final languagePreferences = app<LanguagePreferences>();

    final translateValues = Map<String, String>.of(
      translateLanguages,
    );

    final systemDefault = mapLanguageCodeToTranslateLanguage(
      Localizations.localeOf(context).languageCode,
    );

    translateValues[systemDefault] = '${translateValues[systemDefault]} '
        '(default)';

    final languageCode = languagePreferences.hasSetTranslateLanguage
        ? languagePreferences.translateLanguage
        : systemDefault;

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Card(
          child: RadioDialogTile<String>(
            leading: Icons.translate,
            title: 'translate language',
            subtitle: translateValues[languageCode],
            description: 'Change the language used to translate tweets',
            value: languageCode,
            denseRadioTiles: true,
            titles: translateValues.values.toList(),
            values: translateLanguages.keys.toList(),
            borderRadius: kBorderRadius,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => languagePreferences.translateLanguage = value!);
            },
          ),
        ),
        verticalSpacer,
        const HarpyListCard(
          leading: Icon(Icons.translate),
          title: Text('app language'),
          subtitle: Text('coming soon!'),
          enabled: false,
        ),
      ]),
    );
  }
}
