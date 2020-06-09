import 'package:flutter/material.dart';
import 'package:harpy/components/screens/media_settings_screen.dart';
import 'package:harpy/components/screens/theme_settings_screen.dart';
import 'package:harpy/components/widgets/settings/settings_list.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen();

  Map<String, List<Widget>> _settings(BuildContext context) {
    return {
      "Tweet": [
        ListTile(
          leading: const Icon(Icons.image),
          title: const Text("Media"),
          subtitle: const Text("Settings for videos, images and gifs"),
          onTap: () => HarpyNavigator.push(
            const MediaSettingsScreen(),
            name: "media_settings",
          ),
        ),
      ],
      "Appearance": [
        ListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text("Theme"),
          subtitle: const Text("Select your theme"),
          onTap: () => HarpyNavigator.push(
            const ThemeSettingsScreen(),
            name: "theme_settings",
          ),
        ),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: "Settings",
      body: SettingsList(settings: _settings(context)),
    );
  }
}
