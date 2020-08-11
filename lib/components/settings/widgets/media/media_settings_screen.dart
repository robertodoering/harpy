import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/widgets/common/radio_dialog_tile.dart';
import 'package:harpy/core/preferences/media_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class MediaSettingsScreen extends StatefulWidget {
  static const String route = 'media_settings';

  @override
  _MediaSettingsScreenState createState() => _MediaSettingsScreenState();
}

class _MediaSettingsScreenState extends State<MediaSettingsScreen> {
  final MediaPreferences mediaPreferences = app<MediaPreferences>();

  List<Widget> get _settings {
    return <Widget>[
      RadioDialogTile(
        leading: Icons.signal_wifi_4_bar,
        title: 'Media quality on WiFi',
        description: 'Change the media quality when using WiFi',
        value: mediaPreferences.wifiMediaQuality,
        items: const <String>['High', 'Medium', 'Small'],
        onChanged: (int value) {
          setState(() {
            mediaPreferences.wifiMediaQuality = value;
          });
        },
      ),
      RadioDialogTile(
        leading: Icons.signal_wifi_off,
        title: 'Media quality on mobile data',
        description: 'Change the media quality when using mobile data',
        value: mediaPreferences.nonWifiMediaQuality,
        items: const <String>['High', 'Medium', 'Small'],
        onChanged: (int value) {
          setState(() {
            mediaPreferences.nonWifiMediaQuality = value;
          });
        },
      ),
      RadioDialogTile(
        leading: Icons.visibility,
        title: 'Show media initially',
        description: 'Change when the media should show initially',
        value: mediaPreferences.defaultHideMedia,
        items: const <String>['Always show', 'Only on WiFi', 'Never show'],
        onChanged: (int value) {
          setState(() {
            mediaPreferences.defaultHideMedia = value;
          });
        },
        // todo: implement
        enabled: false,
      ),
      RadioDialogTile(
        leading: Icons.play_circle_outline,
        title: 'Autoplay gifs',
        description: 'Change when gifs should automatically play',
        value: mediaPreferences.autoplayMedia,
        items: const <String>[
          'Always autoplay',
          'Only on WiFi',
          'Never autoplay',
        ],
        onChanged: (int value) {
          setState(() {
            mediaPreferences.autoplayMedia = value;
          });
        },
        enabled: mediaPreferences.enableAutoplayMedia,
      ),
      SwitchListTile(
        secondary: const Icon(Icons.link),
        title: const Text('Always open links externally'),
        value: mediaPreferences.openLinksExternally,
        onChanged: null,
        // todo: implement
        // onChanged: (bool value) {
        //   setState(() => mediaPreferences.openLinksExternally = value);
        // },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: 'Media settings',
      body: ListView(
        // todo: change default physics globally if possible
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: _settings,
      ),
    );
  }
}
