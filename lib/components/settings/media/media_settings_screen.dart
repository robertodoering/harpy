import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class MediaSettingsScreen extends StatefulWidget {
  const MediaSettingsScreen();

  static const String route = 'media_settings';

  @override
  _MediaSettingsScreenState createState() => _MediaSettingsScreenState();
}

class _MediaSettingsScreenState extends State<MediaSettingsScreen> {
  final MediaPreferences mediaPreferences = app<MediaPreferences>();

  final Map<int, String> _mediaQualityValues = <int, String>{
    0: 'always use best quality',
    1: 'only use best quality on wifi',
    2: 'never use best quality',
  };

  final Map<int, String> _autoplayValues = <int, String>{
    0: 'always autoplay',
    1: 'only on wifi',
    2: 'never autoplay',
  };

  List<Widget> _buildSettings(ThemeData theme) {
    return <Widget>[
      RadioDialogTile<int>(
        leading: CupertinoIcons.photo,
        title: 'Tweet image quality',
        subtitle: _mediaQualityValues[mediaPreferences.bestMediaQuality],
        description: 'change when tweet images use the best quality',
        value: mediaPreferences.bestMediaQuality,
        titles: _mediaQualityValues.values.toList(),
        values: _mediaQualityValues.keys.toList(),
        onChanged: (int value) {
          setState(() => mediaPreferences.bestMediaQuality = value);
        },
      ),
      ListTile(
        leading: const SizedBox(),
        title: Row(
          children: <Widget>[
            Icon(CupertinoIcons.info, color: theme.accentColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'media is always downloaded in the best quality',
                style: theme.textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
      RadioDialogTile<int>(
        leading: CupertinoIcons.play_circle,
        title: 'Autoplay gifs',
        subtitle: _autoplayValues[mediaPreferences.autoplayMedia],
        description: 'change when gifs should automatically play',
        value: mediaPreferences.autoplayMedia,
        titles: _autoplayValues.values.toList(),
        values: _autoplayValues.keys.toList(),
        onChanged: (int value) {
          setState(() => mediaPreferences.autoplayMedia = value);
        },
      ),
      RadioDialogTile<int>(
        leading: CupertinoIcons.play_circle,
        title: 'Autoplay videos',
        subtitle: _autoplayValues[mediaPreferences.autoplayVideos],
        description: 'change when videos should automatically play',
        value: mediaPreferences.autoplayVideos,
        titles: _autoplayValues.values.toList(),
        values: _autoplayValues.keys.toList(),
        onChanged: (int value) {
          setState(() => mediaPreferences.autoplayVideos = value);
        },
      ),
      SwitchListTile(
        secondary: const Icon(CupertinoIcons.link),
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
      CustomPopupMenuButton<void>(
        icon: const Icon(CupertinoIcons.ellipsis_vertical),
        onSelected: (_) {
          HapticFeedback.lightImpact();
          setState(mediaPreferences.defaultSettings);
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
    final ThemeData theme = Theme.of(context);

    return HarpyScaffold(
      title: 'media settings',
      actions: _buildActions(),
      buildSafeArea: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: _buildSettings(theme),
      ),
    );
  }
}
