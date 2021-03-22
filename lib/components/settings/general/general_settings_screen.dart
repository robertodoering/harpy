import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

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
        subtitle: const Text('when the app has been updated'),
        value: changelogPreferences.showChangelogDialog,
        onChanged: (bool value) {
          setState(() => changelogPreferences.showChangelogDialog = value);
        },
      ),
      SwitchListTile(
        secondary: const Icon(Icons.speed),
        title: const Text('Performance mode'),
        subtitle: const Text('reduces animations and effects'),
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
      title: 'general',
      buildSafeArea: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: _settings,
      ),
    );
  }
}
