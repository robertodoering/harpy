import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class DownloadButton extends ConsumerWidget {
  const DownloadButton({
    required this.tweet,
    required this.media,
    required this.onDownload,
    this.sizeDelta = 0,
    this.foregroundColor,
  });

  final LegacyTweetData tweet;
  final MediaData media;
  final MediaActionCallback? onDownload;
  final double sizeDelta;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconTheme = IconTheme.of(context);

    final iconSize = iconTheme.size! + sizeDelta;

    return TweetActionButton(
      active: false,
      iconBuilder: (_) => Icon(
        CupertinoIcons.arrow_down_to_line,
        size: iconSize,
      ),
      foregroundColor: foregroundColor,
      iconSize: iconSize,
      sizeDelta: sizeDelta,
      activate: () => onDownload?.call(ref, media),
      deactivate: null,
    );
  }
}
