import 'package:flutter/material.dart';
import 'package:harpy/components/screens/media_settings_screen.dart';
import 'package:harpy/components/screens/theme_settings_screen.dart';
import 'package:harpy/components/widgets/settings/settings_list.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';

class SettingsScreen extends StatelessWidget {
  Map<String, List<ListTile>> _getSettings(BuildContext context) {
    return {
      "Tweet": [
        ListTile(
          leading: Icon(Icons.image),
          title: Text("Media"),
          subtitle: Text("Settings for videos, images and gifs"),
          onTap: () => HarpyNavigator.push(context, MediaSettingsScreen()),
        ),
      ],
      "Appearance": [
        ListTile(
          leading: Icon(Icons.color_lens),
          title: Text("Theme"),
          subtitle: Text("Select your theme"),
          onTap: () => HarpyNavigator.push(context, ThemeSettingsScreen()),
        ),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: "Settings",
      body: SettingsList(settings: _getSettings(context)),
    );
  }
}
