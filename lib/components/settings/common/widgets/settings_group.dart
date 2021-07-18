import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// Builds a [Column] with the [title] above its [children].
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: config.paddingValue * 2),
          child: Text(title, style: theme.textTheme.headline4),
        ),
        defaultSmallVerticalSpacer,
        ...children,
      ],
    );
  }
}
