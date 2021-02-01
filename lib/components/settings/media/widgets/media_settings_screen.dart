import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/common/widgets/radio_dialog_tile.dart';
import 'package:harpy/core/preferences/media_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class MediaSettingsScreen extends StatefulWidget {
  const MediaSettingsScreen();

  static const String route = 'media_settings';

  @override
  _MediaSettingsScreenState createState() => _MediaSettingsScreenState();
}

class _MediaSettingsScreenState extends State<MediaSettingsScreen> {
  final MediaPreferences mediaPreferences = app<MediaPreferences>();

  List<Widget> get _settings {
    return <Widget>[
      RadioDialogTile(
        leading: FeatherIcons.wifi,
        title: 'Media quality on wifi',
        description: 'change the media quality when using wifi',
        value: mediaPreferences.wifiMediaQuality,
        items: const <String>['high', 'medium', 'small'],
        onChanged: (int value) {
          setState(() => mediaPreferences.wifiMediaQuality = value);
        },
      ),
      RadioDialogTile(
        leading: FeatherIcons.wifiOff,
        title: 'Media quality on mobile data',
        description: 'change the media quality when using mobile data',
        value: mediaPreferences.nonWifiMediaQuality,
        items: const <String>['high', 'medium', 'small'],
        onChanged: (int value) {
          setState(() => mediaPreferences.nonWifiMediaQuality = value);
        },
      ),
      RadioDialogTile(
        leading: FeatherIcons.playCircle,
        title: 'Autoplay gifs',
        description: 'change when gifs should automatically play',
        value: mediaPreferences.autoplayMedia,
        items: const <String>[
          'always autoplay',
          'only on wifi',
          'never autoplay',
        ],
        onChanged: (int value) {
          setState(() => mediaPreferences.autoplayMedia = value);
        },
      ),
      RadioDialogTile(
        leading: FeatherIcons.playCircle,
        title: 'Autoplay videos',
        description: 'change when videos should automatically play',
        value: mediaPreferences.autoplayVideos,
        items: const <String>[
          'always autoplay',
          'only on wifi',
          'never autoplay',
        ],
        onChanged: (int value) {
          setState(() => mediaPreferences.autoplayVideos = value);
        },
      ),
      SwitchListTile(
        secondary: const Icon(FeatherIcons.link2),
        title: const Text('Always open links externally'),
        subtitle: const Text('coming soon!'),
        value: mediaPreferences.openLinksExternally,
        onChanged: null,
        // todo: implement
        // onChanged: (bool value) {
        //   setState(() => mediaPreferences.openLinksExternally = value);
        // },
      ),
    ];
  }

  /// Builds the actions for the 'reset to default' button as a [PopupMenuItem].
  List<Widget> _buildActions() {
    return <Widget>[
      PopupMenuButton<void>(
        onSelected: (_) => setState(mediaPreferences.defaultSettings),
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<void>>[
            const PopupMenuItem<void>(
              value: 0,
              child: Text('reset to default'),
            ),
          ];
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: 'media settings',
      actions: _buildActions(),
      buildSafeArea: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: _settings,
      ),
    );
  }
}
