import 'package:flutter/material.dart';
import 'package:harpy/components/screens/theme_settings_screen.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      appBar: "Settings",
      body: ListView(
        children: <Widget>[
          _buildAppearanceColumn(context),
        ],
      ),
    );
  }

  Widget _buildAppearanceColumn(BuildContext context) {
    return SettingsColumn(
      title: "Appearance",
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.color_lens),
          title: Text("Theme"),
          subtitle: Text("Select your theme"),
          onTap: () => HarpyNavigator.push(context, ThemeSettingsScreen()),
        ),
      ],
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
