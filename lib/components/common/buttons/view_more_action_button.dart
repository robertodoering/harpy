import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/misc/modal_sheet_handle.dart';
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
    final MediaQueryData mediaQuery = MediaQuery.of(context);
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
        // todo: use list instead of column
        builder: (BuildContext context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ModalSheetHandle(),
            ...children,
            SizedBox(height: mediaQuery.padding.bottom),
          ],
        ),
      ),
    );
  }
}
