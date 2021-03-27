import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

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
        secondary: const Icon(CupertinoIcons.rectangle_compress_vertical),
        title: const Text('Compact layout'),
        subtitle: const Text('use a visually dense layout'),
        value: layoutPreferences.compactMode,
        onChanged: (bool value) {
          HapticFeedback.lightImpact();
          setState(() => layoutPreferences.compactMode = value);
        },
      ),
      const ListTile(
        leading: Icon(CupertinoIcons.textformat),
        title: Text('Font'),
        subtitle: Text('coming soon!'),
        enabled: false,
      ),
    ];
  }

  /// Builds the actions for the 'reset to default' button as a [PopupMenuItem].
  List<Widget> _buildActions() {
    return <Widget>[
      CustomPopupMenuButton<void>(
        icon: const Icon(CupertinoIcons.ellipsis_vertical),
        onSelected: (_) {
          HapticFeedback.lightImpact();
          setState(layoutPreferences.defaultSettings);
        },
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<void>>[
            const HarpyPopupMenuItem<void>(
              value: 0,
              text: Text('reset to default'),
            ),
          ];
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: 'layout settings',
      actions: _buildActions(),
      buildSafeArea: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: _settings,
      ),
    );
  }
}
