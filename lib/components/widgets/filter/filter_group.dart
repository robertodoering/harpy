import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

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

  Widget _buildTitleRow(Config config, ThemeData theme) {
    return Row(
      children: [
        if (title != null)
          Expanded(
            child: Padding(
              padding: config.edgeInsets,
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
    final config = context.watch<ConfigCubit>().state;

    return Card(
      margin: margin ?? config.edgeInsetsSymmetric(horizontal: true),
      child: AnimatedSize(
        duration: kShortAnimationDuration,
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null || toggleAll != null)
              _buildTitleRow(config, theme),
            ...children,
          ],
        ),
      ),
    );
  }
}
