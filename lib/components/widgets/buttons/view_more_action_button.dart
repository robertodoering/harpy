import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds a button that is intended to be used to show a harpy bottom sheet.
class ViewMoreActionButton extends StatelessWidget {
  const ViewMoreActionButton({
    required this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.sizeDelta = 0,
  });

  final VoidCallback onTap;
  final EdgeInsets padding;
  final double sizeDelta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HarpyButton.flat(
      icon: Icon(
        CupertinoIcons.ellipsis_vertical,
        size: theme.iconTheme.size! + sizeDelta,
      ),
      padding: padding,
      onTap: onTap,
    );
  }
}
