import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/widgets/common/settings_list.dart';
import 'package:harpy/components/settings/widgets/media/media_settings_screen.dart';
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
          onTap: () {},
          enabled: false,
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
