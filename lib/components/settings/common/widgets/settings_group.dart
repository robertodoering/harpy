import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Text(title, style: Theme.of(context).textTheme.headline4),
        ),
        ...children,
      ],
    );
  }
}
