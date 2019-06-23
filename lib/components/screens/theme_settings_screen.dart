import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/components/widgets/theme/theme_card.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:provider/provider.dart';

class ThemeSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: "Theme",
      body: Consumer<ThemeSettingsModel>(
        builder: (context, model, _) {
          return ThemeSelection();
        },
      ),
    );
  }
}

/// Builds the [ThemeCard]s for selecting a different [HarpyTheme].
class ThemeSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final harpyThemes = PredefinedThemes.themes;

    List<Widget> children = [];

    children.addAll(harpyThemes.map((harpyTheme) {
      return ThemeCard(
        harpyTheme: harpyTheme,
        id: harpyThemes.indexOf(harpyTheme),
      );
    }).toList());

    children.add(AddCustomThemeCard());

    return Container(
      padding: const EdgeInsets.all(8.0),
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
