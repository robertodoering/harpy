import 'package:flutter/material.dart';
import 'package:harpy/core/utils/harpy_navigator.dart';
import 'package:harpy/widgets/screens/theme_settings.dart';
import 'package:harpy/widgets/shared/scaffolds.dart';

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
          onTap: () => HarpyNavigator.push(context, ThemeSettings()),
        ),
      ],
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
          child: Text(title, style: Theme.of(context).textTheme.display3),
        ),
      ]..addAll(children),
    );
  }
}
