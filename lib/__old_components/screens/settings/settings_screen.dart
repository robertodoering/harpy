import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/__old_components/screens/settings/theme_settings.dart';
import 'package:harpy/__old_stores/settings_store.dart';
import 'package:harpy/__old_stores/tokens.dart';
import 'package:harpy/theme.dart';
import 'package:harpy/widgets/shared/scaffolds.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen>
    with StoreWatcherMixin<SettingsScreen> {
  SettingsStore store;

  @override
  void initState() {
    super.initState();
    store = listenToStore(Tokens.settings);
  }

  @override
  void dispose() {
    super.dispose();
    unlistenFromStore(store);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HarpyTheme().theme,
      child: HarpyScaffold(
        appBar: "Settings",
        body: ListView(
          children: <Widget>[
            _buildAppearanceColumn(context),
          ],
        ),
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ThemeSettings()),
            );
          },
        ),
      ],
    );
  }
}

class SettingsColumn extends StatelessWidget {
  final String title;

  final List<Widget> children;

  const SettingsColumn({
    this.title,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Text(title, style: HarpyTheme().theme.textTheme.display3),
        ),
      ]..addAll(children),
    );
  }
}
