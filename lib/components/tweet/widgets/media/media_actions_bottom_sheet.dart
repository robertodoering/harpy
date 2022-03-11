import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/rby/rby.dart';
import 'package:share_plus/share_plus.dart';

void showMediaActionsBottomSheet(
  BuildContext context, {
  required Reader read,
  required TweetData tweet,
  required MediaData media,
}) {
  showHarpyBottomSheet<void>(
    context,
    harpyTheme: read(harpyThemeProvider),
    children: [
      HarpyListTile(
        leading: const Icon(CupertinoIcons.square_arrow_left),
        title: const Text('open externally'),
        onTap: () {
          HapticFeedback.lightImpact();
          launchUrl(media.bestUrl);
          Navigator.of(context).pop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.arrow_down_to_line),
        title: const Text('download'),
        onTap: () {
          HapticFeedback.lightImpact();
          // TODO: download
          Navigator.of(context).pop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.share),
        title: const Text('share'),
        onTap: () {
          HapticFeedback.lightImpact();
          Share.share(media.bestUrl);
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
