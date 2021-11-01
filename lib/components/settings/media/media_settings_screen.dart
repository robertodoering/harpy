import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:provider/provider.dart';

class MediaSettingsScreen extends StatefulWidget {
  const MediaSettingsScreen();

  static const String route = 'media_settings';

  @override
  _MediaSettingsScreenState createState() => _MediaSettingsScreenState();
}

class _MediaSettingsScreenState extends State<MediaSettingsScreen> {
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

  List<Widget> _buildSettings(ThemeData theme, Config config) {
    final mediaPreferences = app<MediaPreferences>();

    return [
      RadioDialogTile<int>(
        leading: CupertinoIcons.photo,
        title: 'tweet image quality',
        subtitle: _mediaQualityValues[mediaPreferences.bestMediaQuality],
        description: 'change when tweet images use the best quality',
        value: mediaPreferences.bestMediaQuality,
        titles: _mediaQualityValues.values.toList(),
        values: _mediaQualityValues.keys.toList(),
        onChanged: (value) {
          setState(() => mediaPreferences.bestMediaQuality = value!);
        },
      ),
      defaultSmallVerticalSpacer,
      Row(
        children: [
          // align with the text in the list tile
          SizedBox(width: config.paddingValue * 3 + theme.iconTheme.size!),
          Icon(CupertinoIcons.info, color: theme.colorScheme.secondary),
          defaultHorizontalSpacer,
          Expanded(
            child: Text(
              'media is always downloaded in the best quality',
              style: theme.textTheme.subtitle2!.apply(
                fontSizeDelta: -2,
                color: theme.textTheme.subtitle2!.color!.withOpacity(.8),
              ),
            ),
          ),
        ],
      ),
      defaultVerticalSpacer,
      HarpySwitchTile(
        leading: const Icon(CupertinoIcons.crop),
        title: const Text('crop tweet image'),
        subtitle: const Text('reduces height'),
        value: mediaPreferences.cropImage,
        onChanged: (value) {
          setState(() => mediaPreferences.cropImage = value);
        },
      ),
      RadioDialogTile<int>(
        leading: CupertinoIcons.play_circle,
        title: 'autoplay gifs',
        subtitle: _autoplayValues[mediaPreferences.autoplayMedia],
        description: 'change when gifs should automatically play',
        value: mediaPreferences.autoplayMedia,
        titles: _autoplayValues.values.toList(),
        values: _autoplayValues.keys.toList(),
        onChanged: (value) {
          setState(() => mediaPreferences.autoplayMedia = value!);
        },
      ),
      RadioDialogTile<int>(
        leading: CupertinoIcons.play_circle,
        title: 'autoplay videos',
        subtitle: _autoplayValues[mediaPreferences.autoplayVideos],
        description: 'change when videos should automatically play',
        value: mediaPreferences.autoplayVideos,
        titles: _autoplayValues.values.toList(),
        values: _autoplayValues.keys.toList(),
        onChanged: (value) {
          setState(() => mediaPreferences.autoplayVideos = value!);
        },
      ),
    ];
  }

  /// Builds the actions for the 'reset to default' button as a [PopupMenuItem].
  List<Widget> _buildActions() {
    final mediaPreferences = app<MediaPreferences>();

    return [
      CustomPopupMenuButton<void>(
        icon: const Icon(CupertinoIcons.ellipsis_vertical),
        onSelected: (_) {
          HapticFeedback.lightImpact();
          setState(mediaPreferences.defaultSettings);
        },
        itemBuilder: (_) {
          return [
            const HarpyPopupMenuItem<int>(
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
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    return HarpyScaffold(
      title: 'media settings',
      actions: _buildActions(),
      buildSafeArea: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: _buildSettings(theme, config),
      ),
    );
  }
}
