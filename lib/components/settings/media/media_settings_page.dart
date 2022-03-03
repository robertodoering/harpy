import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class MediaSettingsPage extends ConsumerWidget {
  const MediaSettingsPage();

  static const name = 'media_settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          HarpySliverAppBar(
            title: const Text('media'),
            actions: [
              HarpyPopupMenuButton(
                onSelected: (_) {
                  ref.read(mediaPreferencesProvider.notifier).defaultSettings();
                  ref.read(downloadPathProvider.notifier).initialize();
                },
                itemBuilder: (_) => const [
                  HarpyPopupMenuItem(title: Text('reset to default')),
                ],
              ),
            ],
          ),
          SliverPadding(
            padding: display.edgeInsets,
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
    final harpyTheme = ref.watch(harpyThemeProvider);
    final media = ref.watch(mediaPreferencesProvider);
    final mediaNotifier = ref.watch(mediaPreferencesProvider.notifier);
    final downloadPath = ref.watch(downloadPathProvider);
    final display = ref.watch(displayPreferencesProvider);

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Card(
          child: HarpyRadioDialogTile(
            leading: const Icon(CupertinoIcons.photo),
            title: const Text('tweet image quality'),
            borderRadius: harpyTheme.borderRadius,
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
        verticalSpacer,
        Row(
          children: [
            // align with the text in the list tile
            horizontalSpacer,
            Icon(
              CupertinoIcons.info,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: display.paddingValue * 2),
            Expanded(
              child: Text(
                'media is always downloaded in the best quality',
                style: theme.textTheme.titleSmall!.apply(
                  fontSizeDelta: -2,
                  color: theme.colorScheme.onBackground.withOpacity(.7),
                ),
              ),
            ),
          ],
        ),
        verticalSpacer,
        Card(
          child: HarpySwitchTile(
            leading: const Icon(CupertinoIcons.crop),
            title: const Text('crop tweet image'),
            subtitle: const Text('reduces height'),
            value: media.cropImage,
            borderRadius: harpyTheme.borderRadius,
            onChanged: mediaNotifier.setCropImage,
          ),
        ),
        verticalSpacer,
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
              groupValue: media.autoplayMedia,
              onChanged: mediaNotifier.setAutoplayMedia,
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
        verticalSpacer,
        ExpansionCard(
          title: const Text('download'),
          children: [
            HarpySwitchTile(
              leading: const Icon(CupertinoIcons.arrow_down_to_line),
              title: const Text('show download dialog'),
              value: media.showDownloadDialog,
              onChanged: mediaNotifier.setShowDownloadDialog,
            ),
            HarpyListTile(
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
            HarpyListTile(
              leading: const Icon(CupertinoIcons.folder),
              title: const Text('gif download location'),
              subtitle: Text(downloadPath.gifFullPath ?? ''),
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => const DownloadPathSelectionDialog(type: 'gif'),
              ),
            ),
            HarpyListTile(
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
        ),
      ]),
    );
  }
}
