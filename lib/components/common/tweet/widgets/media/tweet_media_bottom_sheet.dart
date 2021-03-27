import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Shows a harpy bottom sheet for the tweet media actions.
///
/// If the [url] is provided and no callbacks, the default implementation is
/// used with the [url].
/// Otherwise the callback is used.
void showTweetMediaBottomSheet(
  BuildContext context, {
  String url,
  VoidCallback onOpenExternally,
  VoidCallback onDownload,
  VoidCallback onShare,
}) {
  showHarpyBottomSheet<void>(
    context,
    hapticFeedback: true,
    children: <Widget>[
      ListTile(
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
      ListTile(
        leading: const Icon(CupertinoIcons.arrow_down_to_line),
        title: const Text('download'),
        onTap: () {
          if (onDownload != null) {
            onDownload();
          } else {
            defaultOnMediaDownload(url);
          }

          Navigator.of(context).maybePop();
        },
      ),
      ListTile(
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
