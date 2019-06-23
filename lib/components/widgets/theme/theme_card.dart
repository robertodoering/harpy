import 'package:flutter/material.dart';
import 'package:harpy/components/screens/custom_theme_screen.dart';
import 'package:harpy/components/widgets/shared/harpy_background.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';

/// A [Card] showing a selectable [HarpyTheme] that changes the apps theme when
/// selected.
class ThemeCard extends StatelessWidget {
  const ThemeCard({
    @required this.harpyTheme,
    @required this.id,
  });

  final HarpyTheme harpyTheme;
  final int id;

  Widget _buildThemeName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        "${harpyTheme.name}",
        overflow: TextOverflow.ellipsis,
        style: harpyTheme.theme.textTheme.body1,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildThemeColors() {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 4,
          color: harpyTheme.theme.accentColor,
        ),
      ],
    );
  }

  Widget _buildSelectedIcon(ThemeSettingsModel themeModel) {
    if (themeModel.selectedThemeId == id) {
      return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: const Icon(Icons.check),
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = ThemeSettingsModel.of(context);

    return SizedBox(
      width: 120,
      height: 120,
      child: Theme(
        data: harpyTheme.theme,
        child: Card(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: HarpyBackground(
              colors: harpyTheme.backgroundColors,
              child: InkWell(
                borderRadius: BorderRadius.circular(4.0),
                onTap: () => themeModel.changeSelectedTheme(harpyTheme, id),
                child: Column(
                  children: <Widget>[
                    Expanded(child: _buildSelectedIcon(themeModel)),
                    _buildThemeName(context),
                    Expanded(child: _buildThemeColors()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Similar to [ThemeCard] that can be selected to add a new custom theme.
class AddCustomThemeCard extends StatelessWidget {
  void _showProDialog(BuildContext context) {
    // todo
//    showDialog(context: context, builder: (_) => ProFeatureDialog());
    HarpyNavigator.push(CustomThemeScreen());
  }

  @override
  Widget build(BuildContext context) {
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
          ),
        ),
        child: InkWell(
          onTap: () => _showProDialog(context),
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
}
