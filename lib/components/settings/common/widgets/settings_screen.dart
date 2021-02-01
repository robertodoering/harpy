import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/common/widgets/settings_list.dart';
import 'package:harpy/components/settings/general/widgets/general_settings_screen.dart';
import 'package:harpy/components/settings/layout/widgets/layout_settings_screen.dart';
import 'package:harpy/components/settings/media/widgets/media_settings_screen.dart';
import 'package:harpy/components/settings/theme_selection/widgets/theme_selection_screen.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen();

  static const String route = 'settings';

  Map<String, List<Widget>> get _settings {
    return <String, List<Widget>>{
      'tweet': <Widget>[
        ListTile(
          leading: const Icon(FeatherIcons.image),
          title: const Text('Media'),
          subtitle: const Text('settings for videos, images and gifs'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            MediaSettingsScreen.route,
          ),
        ),
      ],
      'appearance': <Widget>[
        ListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text('Theme'),
          subtitle: const Text('select your theme'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            ThemeSelectionScreen.route,
          ),
        ),
        ListTile(
          leading: const Icon(FeatherIcons.layout),
          title: const Text('Layout'),
          subtitle: const Text('change the layout of the app'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            LayoutSettingsScreen.route,
          ),
        ),
      ],
      'other': <Widget>[
        ListTile(
          leading: const Icon(FeatherIcons.sliders),
          title: const Text('General'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            GeneralSettingsScreen.route,
          ),
        ),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: 'settings',
      buildSafeArea: true,
      body: SettingsList(settings: _settings),
    );
  }
}
