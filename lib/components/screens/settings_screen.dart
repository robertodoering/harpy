import 'package:flutter/material.dart';
import 'package:harpy/components/screens/media_settings_screen.dart';
import 'package:harpy/components/screens/theme_settings_screen.dart';
import 'package:harpy/components/widgets/settings/clear_cache_tile.dart';
import 'package:harpy/components/widgets/settings/settings_list.dart';
import 'package:harpy/components/widgets/shared/flare_icons.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/harpy.dart';

class SettingsScreen extends StatelessWidget {
  Map<String, List<Widget>> _settings(BuildContext context) {
    return {
      "Tweet": [
        ListTile(
          leading: const Icon(Icons.image),
          title: const Text("Media"),
          subtitle: const Text("Settings for videos, images and gifs"),
          onTap: () => HarpyNavigator.push(MediaSettingsScreen()),
        ),
      ],
      "Appearance": [
        ListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text("Theme"),
          subtitle: const Text("Select your theme"),
          onTap: () => HarpyNavigator.push(ThemeSettingsScreen()),
        ),
      ],
      "Other": [
        if (Harpy.isFree)
          ListTile(
            leading: const FlareIcon.shiningStar(
              size: 30,
              offset: Offset(-2.5, 0),
            ),
            title: const Text("Harpy Pro"),
            onTap: () {}, // todo
          ),
        ClearCacheListTile(),
        ListTile(
          leading: const FlareIcon.harpyLogo(animate: true),
          title: const Text("About"),
          onTap: () {}, // todo: about screen
        ),
      ]
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
