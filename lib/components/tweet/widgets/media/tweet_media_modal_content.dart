import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/modal_sheet_handle.dart';

// todo: refactor to be used in overlay_action_row
class TweetMediaModalContent extends StatelessWidget {
  const TweetMediaModalContent({
    this.onDownload,
    this.onOpenExternally,
    this.onShare,
  });

  final VoidCallback onOpenExternally;
  final VoidCallback onDownload;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ModalSheetHandle(),
        ListTile(
          leading: const Icon(CupertinoIcons.square_arrow_left),
          title: const Text('open externally'),
          onTap: onOpenExternally,
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.arrow_down_to_line),
          title: const Text('download'),
          onTap: onDownload,
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.share),
          title: const Text('share'),
          onTap: onShare,
        ),
        SizedBox(height: mediaQuery.padding.bottom),
      ],
    );
  }
}
