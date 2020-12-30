import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds a button that opens a modal bottom sheet with the [children] in a
/// column.
class ViewMoreActionButton extends StatelessWidget {
  const ViewMoreActionButton({
    @required this.children,
    this.padding = const EdgeInsets.all(16),
  });

  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    return HarpyButton.flat(
      icon: const Icon(Icons.more_vert),
      padding: padding,
      onTap: () {
        showModalBottomSheet<void>(
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
              Container(
                width: 50,
                height: 2,
                margin: EdgeInsets.all(defaultPaddingValue / 4),
                decoration: BoxDecoration(
                  borderRadius: kDefaultBorderRadius,
                  color: harpyTheme.foregroundColor.withOpacity(.2),
                ),
              ),
              defaultSmallVerticalSpacer,
              ...children,
            ],
          ),
        );
      },
    );
  }
}
