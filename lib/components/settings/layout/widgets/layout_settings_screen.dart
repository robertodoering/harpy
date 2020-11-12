import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/core/preferences/layout_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class LayoutSettingsScreen extends StatefulWidget {
  const LayoutSettingsScreen();

  static const String route = 'layout_settings';

  @override
  _LayoutSettingsScreenState createState() => _LayoutSettingsScreenState();
}

class _LayoutSettingsScreenState extends State<LayoutSettingsScreen> {
  final LayoutPreferences layoutPreferences = app<LayoutPreferences>();

  List<Widget> get _settings {
    return <Widget>[
      SwitchListTile(
        secondary: const Icon(Icons.view_headline),
        title: const Text('Compact layout'),
        subtitle: const Text('Use a visually dense layout'),
        value: layoutPreferences.compactMode,
        onChanged: (bool value) {
          setState(() => layoutPreferences.compactMode = value);
        },
      ),
      const ListTile(
        leading: Icon(Icons.text_format),
        title: Text('Font'),
        subtitle: Text('Coming soon!'),
        enabled: false,
      ),
    ];
  }

  /// Builds the actions for the 'reset to default' button as a [PopupMenuItem].
  List<Widget> _buildActions() {
    return <Widget>[
      PopupMenuButton<void>(
        onSelected: (_) => setState(layoutPreferences.defaultSettings),
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<void>>[
            const PopupMenuItem<void>(
              value: 0,
              child: Text('Reset to default'),
            ),
          ];
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: 'Layout settings',
      actions: _buildActions(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: _settings,
      ),
    );
  }
}
