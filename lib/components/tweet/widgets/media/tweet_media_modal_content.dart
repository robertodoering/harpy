import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/common/misc/modal_sheet_handle.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ModalSheetHandle(),
        ListTile(
          leading: const Icon(FeatherIcons.share),
          title: const Text('open externally'),
          onTap: onOpenExternally,
        ),
        ListTile(
          leading: const Icon(FeatherIcons.download),
          title: const Text('download'),
          onTap: onDownload,
        ),
        ListTile(
          leading: const Icon(FeatherIcons.share2),
          title: const Text('share'),
          onTap: onShare,
        ),
      ],
    );
  }
}
