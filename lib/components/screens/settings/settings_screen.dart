import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/components/shared/scaffolds.dart';
import 'package:harpy/stores/settings_store.dart';
import 'package:harpy/stores/tokens.dart';
import 'package:harpy/theme.dart';

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
    store.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Settings",
          style: HarpyTheme.theme.textTheme.title.copyWith(fontSize: 20.0),
        ),
      ),
      body: Container(),
    );
  }
}
