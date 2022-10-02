import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

void showMediaActionsBottomSheet(
  WidgetRef ref, {
  required MediaData media,
  required TweetDelegates delegates,
}) {
  showHarpyBottomSheet<void>(
    ref.context,
    harpyTheme: ref.read(harpyThemeProvider),
    children: [
      HarpyListTile(
        leading: const Icon(CupertinoIcons.square_arrow_left),
        title: const Text('open externally'),
        onTap: () {
          delegates.onOpenMediaExternally?.call(ref, media);
          Navigator.of(ref.context).pop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.arrow_down_to_line),
        title: const Text('download'),
        onTap: () {
          delegates.onDownloadMedia?.call(ref, media);
          Navigator.of(ref.context).pop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.share),
        title: const Text('share'),
        onTap: () {
          delegates.onShareMedia?.call(ref, media);
          Navigator.of(ref.context).pop();
        },
      ),
    ],
  );
}
