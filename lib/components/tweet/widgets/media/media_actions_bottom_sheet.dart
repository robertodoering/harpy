import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

void showMediaActionsBottomSheet(
  BuildContext context,
  Reader read, {
  required MediaData media,
  required TweetDelegates delegates,
}) {
  showHarpyBottomSheet<void>(
    context,
    harpyTheme: read(harpyThemeProvider),
    children: [
      HarpyListTile(
        leading: const Icon(CupertinoIcons.square_arrow_left),
        title: const Text('open externally'),
        onTap: () {
          delegates.onOpenMediaExternally?.call(context, read, media);
          Navigator.of(context).pop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.arrow_down_to_line),
        title: const Text('download'),
        onTap: () {
          delegates.onDownloadMedia?.call(context, read, media);
          Navigator.of(context).pop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.share),
        title: const Text('share'),
        onTap: () {
          delegates.onShareMedia?.call(context, read, media);
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
