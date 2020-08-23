import 'package:flutter/material.dart';
import 'package:harpy/components/application/bloc/application_bloc.dart';
import 'package:harpy/components/application/bloc/application_event.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/bloc/custom_theme/custom_theme_bloc.dart';
import 'package:harpy/components/settings/widgets/theme/theme_selection/add_custom_theme_card.dart';
import 'package:harpy/components/settings/widgets/theme/theme_selection/theme_card.dart';
import 'package:harpy/core/preferences/theme_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/predefined_themes.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen();

  static const String route = 'theme_selection';

  @override
  _ThemeSelectionScreenState createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  void _changeTheme(
    ApplicationBloc applicationBloc,
    int selectedThemeId,
    int newThemeId,
  ) {
    if (selectedThemeId != newThemeId) {
      setState(() {
        applicationBloc.add(ChangeThemeEvent(
          id: newThemeId,
          saveSelection: true,
        ));
      });
    }
  }

  List<Widget> _buildPredefinedThemes(
    ApplicationBloc applicationBloc,
    int selectedThemeId,
  ) {
    return <Widget>[
      for (int i = 0; i < predefinedThemes.length; i++)
        ThemeCard(
          predefinedThemes[i],
          selected: i == selectedThemeId,
          onTap: () => _changeTheme(applicationBloc, selectedThemeId, i),
        ),
    ];
  }

  List<Widget> _buildCustomThemes(
    ApplicationBloc applicationBloc,
    int selectedThemeId,
    List<HarpyTheme> customThemes,
  ) {
    return <Widget>[
      for (int i = 0; i < customThemes.length; i++)
        ThemeCard(
          customThemes[i],
          selected: i + 10 == selectedThemeId,
          onTap: () => _changeTheme(applicationBloc, selectedThemeId, i + 10),
          // todo: delete action
          // todo: edit action
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applicationBloc = ApplicationBloc.of(context);
    final CustomThemeBloc customThemeBloc = applicationBloc.customThemeBloc;
    final int selectedThemeId = app<ThemePreferences>().selectedTheme;

    return HarpyScaffold(
      title: 'Theme selection',
      body: Column(
        children: <Widget>[
          ..._buildPredefinedThemes(applicationBloc, selectedThemeId),
          const AddCustomThemeCard(),
          ..._buildCustomThemes(
            applicationBloc,
            selectedThemeId,
            customThemeBloc.customThemes,
          ),
        ],
      ),
    );
  }
}
