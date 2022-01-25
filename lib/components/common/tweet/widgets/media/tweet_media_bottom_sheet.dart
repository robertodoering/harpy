import 'package:flutter/cupertino.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Shows a harpy bottom sheet for the tweet media actions.
///
/// If the [url] is provided and no callbacks, the default implementation is
/// used with the [url].
/// Otherwise the callback is used.
void showTweetMediaBottomSheet(
  BuildContext context, {
  String? url,
  MediaType? mediaType,
  VoidCallback? onOpenExternally,
  VoidCallback? onDownload,
  VoidCallback? onShare,
}) {
  assert(onOpenExternally != null || (url != null && mediaType != null));
  assert(onDownload != null || (url != null && mediaType != null));
  assert(onShare != null || (url != null && mediaType != null));

  showHarpyBottomSheet<void>(
    context,
    children: [
      HarpyListTile(
        leading: const Icon(CupertinoIcons.square_arrow_left),
        title: const Text('open externally'),
        onTap: () {
          if (onOpenExternally != null) {
            onOpenExternally();
          } else {
            defaultOnMediaOpenExternally(url);
          }

          Navigator.of(context).maybePop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.arrow_down_to_line),
        title: const Text('download'),
        onTap: () {
          if (onDownload != null) {
            onDownload();
          } else {
            defaultOnMediaDownload(
              downloadPathCubit: context.read(),
              type: mediaType,
              url: url,
            );
          }

          Navigator.of(context).maybePop();
        },
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.share),
        title: const Text('share'),
        onTap: () {
          if (onShare != null) {
            onShare();
          } else {
            defaultOnMediaShare(url);
          }

          Navigator.of(context).maybePop();
        },
      )
    ],
  );
}
