import 'package:flutter/material.dart';
import 'package:harpy/components/screens/custom_theme_screen.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/components/widgets/theme/theme_card.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/core/misc/theme.dart';
import 'package:harpy/models/settings_model.dart';
import 'package:harpy/models/theme_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ThemeSettings extends StatelessWidget {
  final List<HarpyTheme> _harpyThemes = [
    HarpyTheme.light(),
    HarpyTheme.dark(),
  ];

  Widget _buildThemeSelection(BuildContext context) {
    final themeModel = ThemeModel.of(context);

    List<Widget> children = [];

    children.addAll(_harpyThemes.map((harpyTheme) {
      return ThemeCard(
        harpyTheme: harpyTheme,
        selected: themeModel.harpyTheme.name == harpyTheme.name,
        onTap: () => themeModel.updateTheme(harpyTheme),
      );
    }).toList());

    children.add(_buildAddCustomTheme(context));

    return Container(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        children: children,
      ),
    );
  }

  Widget _buildPreview() {
    return Container(); // todo
  }

  Widget _buildAddCustomTheme(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              width: 1.0,
              color: Theme.of(context).dividerColor,
            )),
        child: InkWell(
          onTap: () => HarpyNavigator.push(context, CustomThemeScreen()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Custom"),
              Icon(Icons.add),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(SettingsModel settingsModel) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.refresh),
        onPressed: settingsModel.loadCustomThemes,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final settingsModel = SettingsModel.of(context);

    return HarpyScaffold(
      appBar: "Theme",
      actions: _buildActions(settingsModel),
      body: ScopedModelDescendant<SettingsModel>(
        builder: (context, _, model) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildThemeSelection(context),
              ),
              Expanded(child: _buildPreview()),
            ],
          );
        },
      ),
    );
  }
}
