import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/theme/bloc/theme_bloc.dart';
import 'package:harpy/components/settings/theme/bloc/theme_event.dart';
import 'package:harpy/components/settings/widgets/theme/theme_selection/add_custom_theme_card.dart';
import 'package:harpy/components/settings/widgets/theme/theme_selection/theme_card.dart';
import 'package:harpy/core/preferences/theme_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/predefined_themes.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen();

  static const String route = 'theme_selection';

  @override
  _ThemeSelectionScreenState createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  void _changeTheme(
    ThemeBloc themeBloc,
    int selectedThemeId,
    int newThemeId,
  ) {
    if (selectedThemeId != newThemeId) {
      setState(() {
        themeBloc.add(ChangeThemeEvent(
          id: newThemeId,
          saveSelection: true,
        ));
      });
    }
  }

  List<Widget> _buildPredefinedThemes(
    ThemeBloc themeBloc,
    int selectedThemeId,
  ) {
    return <Widget>[
      for (int i = 0; i < predefinedThemes.length; i++)
        ThemeCard(
          predefinedThemes[i],
          selected: i == selectedThemeId,
          onTap: () => _changeTheme(themeBloc, selectedThemeId, i),
        ),
    ];
  }

  List<Widget> _buildCustomThemes(
    ThemeBloc themeBloc,
    int selectedThemeId,
  ) {
    return <Widget>[
      for (int i = 0; i < themeBloc.customThemes.length; i++)
        ThemeCard(
          themeBloc.customThemes[i],
          selected: i + 10 == selectedThemeId,
          onTap: () => _changeTheme(themeBloc, selectedThemeId, i + 10),
          // todo: delete action
          // todo: edit action
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeBloc themeBloc = ThemeBloc.of(context);
    final int selectedThemeId = app<ThemePreferences>().selectedTheme;

    return HarpyScaffold(
      title: 'Theme selection',
      body: Column(
        children: <Widget>[
          ..._buildPredefinedThemes(themeBloc, selectedThemeId),
          const AddCustomThemeCard(),
          ..._buildCustomThemes(
            themeBloc,
            selectedThemeId,
          ),
        ],
      ),
    );
  }
}
