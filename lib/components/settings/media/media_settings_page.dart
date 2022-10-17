import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class MediaSettingsPage extends ConsumerWidget {
  const MediaSettingsPage();

  static const name = 'media_settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          HarpySliverAppBar(
            title: const Text('media'),
            actions: [
              RbyPopupMenuButton(
                onSelected: (_) {
                  ref.read(mediaPreferencesProvider.notifier).defaultSettings();
                  ref.read(downloadPathProvider.notifier).initialize();
                },
                itemBuilder: (_) => const [
                  RbyPopupMenuListTile(
                    value: true,
                    title: Text('reset to default'),
                  ),
                ],
              ),
            ],
          ),
          SliverPadding(
            padding: theme.spacing.edgeInsets,
            sliver: const _MediaSettingsList(),
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}

class _MediaSettingsList extends ConsumerWidget {
  const _MediaSettingsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final media = ref.watch(mediaPreferencesProvider);
    final mediaNotifier = ref.watch(mediaPreferencesProvider.notifier);

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Card(
          child: HarpyRadioDialogTile(
            leading: const Icon(CupertinoIcons.photo),
            title: const Text('tweet image quality'),
            borderRadius: theme.shape.borderRadius,
            dialogTitle: const Text(
              'change when tweet images use the best quality',
            ),
            entries: const {
              0: Text('always use best quality'),
              1: Text('only use best quality on wifi'),
              2: Text('never use best quality'),
            },
            groupValue: media.bestMediaQuality,
            onChanged: mediaNotifier.setBestMediaQuality,
          ),
        ),
        VerticalSpacer.normal,
        const _MediaInfoMessage(),
        VerticalSpacer.normal,
        Card(
          child: RbySwitchTile(
            leading: const Icon(CupertinoIcons.crop),
            title: const Text('crop tweet image'),
            subtitle: const Text('reduces height'),
            value: media.cropImage,
            borderRadius: theme.shape.borderRadius,
            onChanged: mediaNotifier.setCropImage,
          ),
        ),
        VerticalSpacer.normal,
        Card(
          child: RbySwitchTile(
            leading: const Icon(CupertinoIcons.eye_slash_fill),
            title: const Text('hide possibly sensitive media'),
            value: media.hidePossiblySensitive,
            borderRadius: theme.shape.borderRadius,
            onChanged: mediaNotifier.setHidePossiblySensitive,
          ),
        ),
        VerticalSpacer.normal,
        Card(
          child: RbySwitchTile(
            leading: const Icon(CupertinoIcons.link),
            title: const Text('open links externally'),
            value: media.openLinksExternally,
            borderRadius: theme.shape.borderRadius,
            onChanged: mediaNotifier.setOpenLinksExternally,
          ),
        ),
        VerticalSpacer.normal,
        ExpansionCard(
          title: const Text('autoplay'),
          children: [
            HarpyRadioDialogTile(
              leading: const Icon(CupertinoIcons.play_circle),
              title: const Text('autoplay gifs'),
              dialogTitle: const Text(
                'change when gifs should automatically play',
              ),
              entries: const {
                0: Text('always autoplay'),
                1: Text('only on wifi'),
                2: Text('never autoplay'),
              },
              groupValue: media.autoplayGifs,
              onChanged: mediaNotifier.setAutoplayGifs,
            ),
            HarpyRadioDialogTile(
              leading: const Icon(CupertinoIcons.play_circle),
              title: const Text('autoplay videos'),
              dialogTitle: const Text(
                'change when videos should automatically play',
              ),
              entries: const {
                0: Text('always autoplay'),
                1: Text('only on wifi'),
                2: Text('never autoplay'),
              },
              groupValue: media.autoplayVideos,
              onChanged: mediaNotifier.setAutoplayVideos,
            ),
          ],
        ),
        VerticalSpacer.normal,
        Card(
          child: RbySwitchTile(
            leading: const Icon(CupertinoIcons.volume_off),
            title: const Text('start video playback muted'),
            value: media.startVideoPlaybackMuted,
            borderRadius: theme.shape.borderRadius,
            onChanged: mediaNotifier.setStartVideoPlaybackMuted,
          ),
        ),
        VerticalSpacer.normal,
        const _MediaDownloadSettings(),
      ]),
    );
  }
}

class _MediaDownloadSettings extends ConsumerStatefulWidget {
  const _MediaDownloadSettings();

  @override
  _MediaDownloadSettingsState createState() => _MediaDownloadSettingsState();
}

class _MediaDownloadSettingsState
    extends ConsumerState<_MediaDownloadSettings> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(downloadPathProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = ref.watch(mediaPreferencesProvider);
    final mediaNotifier = ref.watch(mediaPreferencesProvider.notifier);
    final downloadPath = ref.watch(downloadPathProvider);

    return ExpansionCard(
      title: const Text('download'),
      children: [
        RbySwitchTile(
          leading: const Icon(CupertinoIcons.arrow_down_to_line),
          title: const Text('show download dialog'),
          value: media.showDownloadDialog,
          onChanged: mediaNotifier.setShowDownloadDialog,
        ),
        RbyListTile(
          leading: const Icon(CupertinoIcons.folder),
          title: const Text('image download location'),
          subtitle: Text(downloadPath.imageFullPath ?? ''),
          onTap: () => showDialog<void>(
            context: context,
            builder: (_) => const DownloadPathSelectionDialog(
              type: 'image',
            ),
          ),
        ),
        RbyListTile(
          leading: const Icon(CupertinoIcons.folder),
          title: const Text('gif download location'),
          subtitle: Text(downloadPath.gifFullPath ?? ''),
          onTap: () => showDialog<void>(
            context: context,
            builder: (_) => const DownloadPathSelectionDialog(type: 'gif'),
          ),
        ),
        RbyListTile(
          leading: const Icon(CupertinoIcons.folder),
          title: const Text('video download location'),
          subtitle: Text(downloadPath.videoFullPath ?? ''),
          onTap: () => showDialog<void>(
            context: context,
            builder: (_) => const DownloadPathSelectionDialog(
              type: 'video',
            ),
          ),
        ),
      ],
    );
  }
}

class _MediaInfoMessage extends StatelessWidget {
  const _MediaInfoMessage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // align with the text in the list tile
        HorizontalSpacer.normal,
        Icon(
          CupertinoIcons.info,
          color: theme.colorScheme.primary,
        ),
        SizedBox(width: theme.spacing.base * 2),
        Expanded(
          child: Text(
            'media is always downloaded in the best quality',
            style: theme.textTheme.titleSmall!.apply(
              fontSizeDelta: -2,
              color: theme.colorScheme.onBackground.withOpacity(.7),
            ),
          ),
        ),
        HorizontalSpacer.normal,
      ],
    );
  }
}
