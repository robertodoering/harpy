import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class FilterGroup extends StatelessWidget {
  const FilterGroup({
    required this.children,
    this.title,
    this.margin,
    this.toggleAll,
    this.allToggled = true,
  });

  final String? title;
  final EdgeInsets? margin;
  final List<Widget> children;
  final VoidCallback? toggleAll;
  final bool allToggled;

  Widget _buildTitleRow(ThemeData theme) {
    return Row(
      children: <Widget>[
        if (title != null)
          Expanded(
            child: Padding(
              padding: DefaultEdgeInsets.all(),
              child: Text(title!, style: theme.textTheme.subtitle2),
            ),
          ),
        if (toggleAll != null)
          HarpyButton.flat(
            dense: true,
            icon: allToggled
                ? const Icon(Icons.toggle_on_outlined)
                : const Icon(Icons.toggle_off_outlined),
            onTap: toggleAll,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: margin ?? DefaultEdgeInsets.symmetric(horizontal: true),
      child: CustomAnimatedSize(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (title != null || toggleAll != null) _buildTitleRow(theme),
            ...children,
          ],
        ),
      ),
    );
  }
}
