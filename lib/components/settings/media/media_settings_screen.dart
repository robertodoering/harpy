import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class MediaSettingsScreen extends StatefulWidget {
  const MediaSettingsScreen();

  static const route = 'media_settings';

  @override
  State<MediaSettingsScreen> createState() => _MediaSettingsScreenState();
}

class _MediaSettingsScreenState extends State<MediaSettingsScreen> {
  final _mediaQualityValues = {
    0: 'always use best quality',
    1: 'only use best quality on wifi',
    2: 'never use best quality',
  };

  final _autoplayValues = {
    0: 'always autoplay',
    1: 'only on wifi',
    2: 'never autoplay',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final downloadPathCubit = context.watch<DownloadPathCubit>();

    final mediaPreferences = app<MediaPreferences>();

    return HarpyScaffold(
      title: 'media settings',
      buildSafeArea: true,
      actions: [
        Builder(
          builder: (context) => CustomPopupMenuButton<void>(
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
            onSelected: (_) {
              HapticFeedback.lightImpact();
              setState(app<MediaPreferences>().defaultSettings);
              downloadPathCubit.initialize();
            },
            itemBuilder: (_) => const [
              HarpyPopupMenuItem<int>(
                value: 0,
                text: Text('reset to default'),
              ),
            ],
          ),
        ),
      ],
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          RadioDialogTile<int>(
            leading: CupertinoIcons.photo,
            title: 'tweet image quality',
            subtitle: _mediaQualityValues[mediaPreferences.bestMediaQuality],
            description: 'change when tweet images use the best quality',
            value: mediaPreferences.bestMediaQuality,
            titles: _mediaQualityValues.values.toList(),
            values: _mediaQualityValues.keys.toList(),
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => mediaPreferences.bestMediaQuality = value!);
            },
          ),
          smallVerticalSpacer,
          Row(
            children: [
              // align with the text in the list tile
              SizedBox(width: config.paddingValue * 3 + theme.iconTheme.size!),
              Icon(CupertinoIcons.info, color: theme.colorScheme.secondary),
              horizontalSpacer,
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
          verticalSpacer,
          HarpySwitchTile(
            leading: const Icon(CupertinoIcons.crop),
            title: const Text('crop tweet image'),
            subtitle: const Text('reduces height'),
            value: mediaPreferences.cropImage,
            onChanged: (value) {
              HapticFeedback.lightImpact();
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
              HapticFeedback.lightImpact();
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
              HapticFeedback.lightImpact();
              setState(() => mediaPreferences.autoplayVideos = value!);
            },
          ),
          HarpySwitchTile(
            leading: const Icon(CupertinoIcons.arrow_down_to_line),
            title: const Text('show download dialog'),
            value: mediaPreferences.showDownloadDialog,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => mediaPreferences.showDownloadDialog = value);
            },
          ),
          HarpyListTile(
            leading: const Icon(CupertinoIcons.folder),
            title: const Text('image download location'),
            subtitle: Text(downloadPathCubit.state.imageFullPath ?? ''),
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: downloadPathCubit,
                child: const DownloadPathSelectionDialog(type: 'image'),
              ),
            ),
          ),
          HarpyListTile(
            leading: const Icon(CupertinoIcons.folder),
            title: const Text('gif download location'),
            subtitle: Text(downloadPathCubit.state.gifFullPath ?? ''),
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: downloadPathCubit,
                child: const DownloadPathSelectionDialog(type: 'gif'),
              ),
            ),
          ),
          HarpyListTile(
            leading: const Icon(CupertinoIcons.folder),
            title: const Text('video download location'),
            subtitle: Text(downloadPathCubit.state.videoFullPath ?? ''),
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: downloadPathCubit,
                child: const DownloadPathSelectionDialog(type: 'video'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
