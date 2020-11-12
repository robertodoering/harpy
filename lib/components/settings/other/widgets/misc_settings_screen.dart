import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/core/preferences/changelog_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class MiscSettingsScreen extends StatefulWidget {
  const MiscSettingsScreen();

  static const String route = 'misc_settings';

  @override
  _MiscSettingsScreenState createState() => _MiscSettingsScreenState();
}

class _MiscSettingsScreenState extends State<MiscSettingsScreen> {
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
      title: 'Miscellaneous Settings',
      body: ListView(
        padding: EdgeInsets.zero,
        children: _settings,
      ),
    );
  }
}
