import 'package:flutter/material.dart';

/// Builds a [ListView] with [SettingsColumn]s for each entry in [settings].
class SettingsList extends StatelessWidget {
  const SettingsList({
    @required this.settings,
  });

  final Map<String, List<Widget>> settings;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: settings.entries.map((entry) {
        return SettingsColumn(
          title: entry.key,
          children: entry.value,
        );
      }).toList(),
    );
  }
}

/// Builds a [Column] with the [title] above its [children].
class SettingsColumn extends StatelessWidget {
  const SettingsColumn({
    @required this.title,
    @required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Text(title, style: Theme.of(context).textTheme.display1),
        ),
        ...children,
      ],
    );
  }
}
