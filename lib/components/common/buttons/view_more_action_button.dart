import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds a button that opens a modal bottom sheet with the [children] in a
/// column.
class ViewMoreActionButton extends StatelessWidget {
  const ViewMoreActionButton({
    @required this.children,
    this.padding = const EdgeInsets.all(16),
    this.sizeDelta = 0,
  });

  final List<Widget> children;
  final EdgeInsets padding;
  final double sizeDelta;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return HarpyButton.flat(
      icon: Icon(Icons.more_vert, size: theme.iconTheme.size + sizeDelta),
      padding: padding,
      onTap: () => showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: kDefaultRadius,
            topRight: kDefaultRadius,
          ),
        ),
        builder: (BuildContext context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // handle
            ViewMoreModalHeader(),
            ...children,
          ],
        ),
      ),
    );
  }
}

class ViewMoreModalHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    return Container(
      width: 40,
      height: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: kDefaultBorderRadius,
        color: harpyTheme.foregroundColor.withOpacity(.2),
      ),
    );
  }
}
