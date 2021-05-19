import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/animations/animation_constants.dart';

class DownloadStatusMessage extends StatefulWidget {
  const DownloadStatusMessage({
    required this.notifier,
    Key? key,
  }) : super(key: key);

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
    final status = widget.notifier.value;

    return AnimatedSwitcher(
      duration: kShortAnimationDuration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: Row(
        key: ValueKey(status),
        children: [
          Flexible(child: Text(status.message)),
          if (status.state == DownloadState.inProgress) ...[
            defaultHorizontalSpacer,
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(),
            ),
          ],
        ],
      ),
    );
  }
}
