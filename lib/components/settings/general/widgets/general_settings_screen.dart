import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/core/preferences/changelog_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen();

  static const String route = 'general_settings';

  @override
  _GeneralSettingsScreenState createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  final ChangelogPreferences changelogPreferences = app<ChangelogPreferences>();

  List<Widget> get _settings {
    return <Widget>[
      SwitchListTile(
        secondary: const Icon(Icons.update),
        title: const Text('Show changelog dialog'),
        subtitle: const Text('When the app has been updated to a new version'),
        value: changelogPreferences.showChangelogDialog,
        onChanged: (bool value) {
          setState(() => changelogPreferences.showChangelogDialog = value);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: 'General',
      body: ListView(
        padding: EdgeInsets.zero,
        children: _settings,
      ),
    );
  }
}
