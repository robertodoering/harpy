import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_bloc.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_event.dart';
import 'package:harpy/core/preferences/changelog_preferences.dart';
import 'package:harpy/core/preferences/general_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen();

  static const String route = 'general_settings';

  @override
  _GeneralSettingsScreenState createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  final ChangelogPreferences changelogPreferences = app<ChangelogPreferences>();
  final GeneralPreferences generalPreferences = app<GeneralPreferences>();

  List<Widget> get _settings {
    return <Widget>[
      SwitchListTile(
        secondary: const Icon(Icons.update),
        title: const Text('Show changelog dialog'),
        subtitle: const Text('When the app has been updated'),
        value: changelogPreferences.showChangelogDialog,
        onChanged: (bool value) {
          setState(() => changelogPreferences.showChangelogDialog = value);
        },
      ),
      SwitchListTile(
        secondary: const Icon(Icons.speed),
        title: const Text('Performance mode'),
        subtitle: const Text('Reduces animations and effects'),
        value: generalPreferences.performanceMode,
        onChanged: (bool value) {
          setState(() => generalPreferences.performanceMode = value);
          context.read<ThemeBloc>().add(const RefreshTheme());
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: 'General',
      buildSafeArea: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: _settings,
      ),
    );
  }
}
