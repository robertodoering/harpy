import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/common/widgets/settings_list.dart';
import 'package:harpy/components/settings/layout/widgets/layout_settings_screen.dart';
import 'package:harpy/components/settings/media/widgets/media_settings_screen.dart';
import 'package:harpy/components/settings/other/widgets/misc_settings_screen.dart';
import 'package:harpy/components/settings/theme_selection/widgets/theme_selection_screen.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen();

  static const String route = 'settings';

  Map<String, List<Widget>> get _settings {
    return <String, List<Widget>>{
      'Tweet': <Widget>[
        ListTile(
          leading: const Icon(Icons.image),
          title: const Text('Media'),
          subtitle: const Text('Settings for videos, images and gifs'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            MediaSettingsScreen.route,
          ),
        ),
      ],
      'Appearance': <Widget>[
        ListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text('Theme'),
          subtitle: const Text('Select your theme'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            ThemeSelectionScreen.route,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.view_agenda),
          title: const Text('Layout'),
          subtitle: const Text('Change the layout of the app'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            LayoutSettingsScreen.route,
          ),
        ),
      ],
      'Other': <Widget>[
        ListTile(
          leading: const Icon(Icons.miscellaneous_services),
          title: const Text('Miscellaneous Settings'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            MiscSettingsScreen.route,
          ),
        ),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: 'Settings',
      body: SettingsList(settings: _settings),
    );
  }
}
