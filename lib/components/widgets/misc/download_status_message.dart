import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds a status message based on the [DownloadStatus] of the [notifier].
class DownloadStatusMessage extends StatefulWidget {
  const DownloadStatusMessage({
    required this.notifier,
  });

  final ValueNotifier<DownloadStatus> notifier;

  @override
  _DownloadStatusMessageState createState() => _DownloadStatusMessageState();
}

class _DownloadStatusMessageState extends State<DownloadStatusMessage> {
  @override
  void initState() {
    super.initState();

    widget.notifier.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = widget.notifier.value;

    return AnimatedSwitcher(
      duration: kShortAnimationDuration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: Row(
        key: ValueKey(status),
        children: [
          Flexible(
            child: Text(
              status.message,
              style: theme.textTheme.subtitle2,
            ),
          ),
          if (status.state == DownloadState.inProgress) ...[
            horizontalSpacer,
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
