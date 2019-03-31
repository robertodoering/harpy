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

/// Builds a [Column] with the [title] above its [child] or [children].
///
/// Can either have a list of [children] or a single [child] but not both.
class SettingsColumn extends StatelessWidget {
  const SettingsColumn({
    @required this.title,
    this.children,
    this.child,
  }) : assert(children != null && child == null ||
            children == null && child != null);

  final String title;
  final List<Widget> children;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [];

    content.add(Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Text(title, style: Theme.of(context).textTheme.display3),
    ));

    if (child != null) {
      content.add(child);
    }

    if (children != null) {
      content.addAll(children);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content,
    );
  }
}
