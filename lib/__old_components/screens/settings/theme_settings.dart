import 'package:flutter/material.dart';
import 'package:harpy/__old_stores/settings_store.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/theme.dart';
import 'package:harpy/widgets/shared/scaffolds.dart';
import 'package:harpy/widgets/shared/tweet/old_tweet_tile.dart';

class ThemeSettings extends StatefulWidget {
  @override
  ThemeSettingsState createState() => ThemeSettingsState();
}

class ThemeSettingsState extends State<ThemeSettings> {
  SettingsStore store;

  List<HarpyTheme> _harpyThemes = [
    HarpyTheme.light(),
    HarpyTheme.dark(),
  ];

  @override
  Widget build(BuildContext context) {
    // todo: load custom themes
    return HarpyScaffold(
      appBar: HarpyTheme().name,
      themeData: HarpyTheme().theme,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildThemeSelection(),
          ),
          Expanded(child: _buildPreview()),
        ],
      ),
    );
  }

  Widget _buildThemeSelection() {
    List<Widget> children = [];

    children
      ..addAll(_harpyThemes.map((harpyTheme) {
        return ThemeCard(
          harpyTheme: harpyTheme,
          selected: harpyTheme.name == HarpyTheme().name,
          onTap: () {
            setState(() {
              SettingsStore.setTheme(harpyTheme);
            });
          },
        );
      }).toList());

    children.add(_buildAddCustomTheme());

    return Container(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        children: children,
      ),
    );
  }

  Widget _buildPreview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Divider(height: 0.0),
        OldTweetTile(
          openUserProfile: false,
          tweet: Tweet.mock(),
        ),
        Divider(height: 0.0),
      ],
    );
  }

  Widget _buildAddCustomTheme() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              width: 1.0,
              color: HarpyTheme().theme.dividerColor,
            )),
        child: InkWell(
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Custom"),
              Icon(Icons.add),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeCard extends StatelessWidget {
  final HarpyTheme harpyTheme;
  final bool selected;
  final VoidCallback onTap;

  const ThemeCard({
    @required this.harpyTheme,
    @required this.selected,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Theme(
        data: harpyTheme.theme,
        child: Card(
          child: InkWell(
            onTap: onTap,
            child: Column(
              children: <Widget>[
                Expanded(child: _buildSelectedIcon()),
                _buildThemeName(),
                Expanded(child: _buildThemeColors()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeName() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      width: double.infinity,
      color: harpyTheme.theme.primaryColor,
      child: Text(
        harpyTheme.name,
        style: HarpyTheme().theme.textTheme.body1.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildThemeColors() {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 5,
          color: harpyTheme.theme.accentColor,
        ),
      ],
    );
  }

  Widget _buildSelectedIcon() {
    return selected
        ? Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.check),
            ),
          )
        : Container();
  }
}
