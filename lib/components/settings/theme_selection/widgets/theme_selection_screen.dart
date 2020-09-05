import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_bloc.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_event.dart';
import 'package:harpy/components/settings/theme_selection/widgets/add_custom_theme_card.dart';
import 'package:harpy/components/settings/theme_selection/widgets/theme_card.dart';
import 'package:harpy/core/preferences/theme_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/predefined_themes.dart';
import 'package:harpy/misc/harpy_navigator.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen();

  static const String route = 'theme_selection';

  @override
  _ThemeSelectionScreenState createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen>
    with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    app<HarpyNavigator>().routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    super.dispose();
    app<HarpyNavigator>().routeObserver.unsubscribe(this);
  }

  @override
  void didPopNext() {
    // rebuild in case custom themes changes
    setState(() {});
  }

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
          ..._buildCustomThemes(
            themeBloc,
            selectedThemeId,
          ),
          const AddCustomThemeCard(),
        ],
      ),
    );
  }
}
