import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/components/widgets/theme/theme_card.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';

class ThemeSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: "Theme",
      body: _ThemeSettingsScreenContent(),
    );
  }
}

/// Builds the [ThemeCard]s for selecting a different [HarpyTheme].
class _ThemeSettingsScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeSettingsModel = ThemeSettingsModel.of(context);

    final themes = List.of(PredefinedThemes.themes);

    // load and add all custom themes
    // todo: don't always reload themes, instead load once and update when
    //  changed
    themeSettingsModel.loadCustomThemes();
    themes.addAll(themeSettingsModel.customThemes.map(
      (themeData) => HarpyTheme.fromData(themeData),
    ));

    final List<Widget> children = [
      ...themes.map((harpyTheme) => ThemeCard(
            harpyTheme: harpyTheme,
            id: themes.indexOf(harpyTheme),
          )),
      AddCustomThemeCard(),
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: children,
        ),
      ),
    );
  }
}
