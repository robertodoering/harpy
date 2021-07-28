import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen();

  static const String route = 'settings';

  Map<String, List<Widget>> get _settings {
    return {
      'tweet': [
        HarpyListTile(
          leading: const Icon(CupertinoIcons.photo),
          title: const Text('media'),
          subtitle: const Text('settings for videos, images and gifs'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            MediaSettingsScreen.route,
          ),
        ),
      ],
      'appearance': [
        HarpyListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text('theme'),
          subtitle: const Text('select your theme'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            ThemeSelectionScreen.route,
          ),
        ),
        HarpyListTile(
          leading: const Icon(FeatherIcons.layout),
          title: const Text('display'),
          subtitle: const Text('change the look of the app'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            DisplaySettingsScreen.route,
          ),
        ),
      ],
      'other': [
        HarpyListTile(
          leading: const Icon(FeatherIcons.sliders),
          title: const Text('general'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            GeneralSettingsScreen.route,
          ),
        ),
        HarpyListTile(
          leading: const Icon(Icons.translate),
          title: const Text('language'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            LanguageSettingsScreen.route,
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
