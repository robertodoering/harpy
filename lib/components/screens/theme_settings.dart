import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/misc/theme.dart';
import 'package:harpy/models/theme_model.dart';

class ThemeSettings extends StatelessWidget {
  final List<HarpyTheme> _harpyThemes = [
    HarpyTheme.light(),
    HarpyTheme.dark(),
  ];

  @override
  Widget build(BuildContext context) {
    // todo: load custom themes
    return HarpyScaffold(
      appBar: "Theme",
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildThemeSelection(context),
          ),
          Expanded(child: _buildPreview()),
        ],
      ),
    );
  }

  Widget _buildThemeSelection(BuildContext context) {
    final themeModel = ThemeModel.of(context);

    List<Widget> children = [];

    children.addAll(_harpyThemes.map((harpyTheme) {
      return ThemeCard(
        harpyTheme: harpyTheme,
        selected: themeModel.harpyTheme.name == harpyTheme.name,
        onTap: () => themeModel.updateTheme(harpyTheme),
      );
    }).toList());

    children.add(_buildAddCustomTheme(context));

    return Container(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        children: children,
      ),
    );
  }

  Widget _buildPreview() {
    return Container(); // todo
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
//        Divider(height: 0.0),
//        TweetTile(
//          openUserProfile: false,
//          tweet: Tweet.mock(),
//        ),
//        Divider(height: 0.0),
//      ],
//    );
  }

  Widget _buildAddCustomTheme(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              width: 1.0,
              color: Theme.of(context).dividerColor,
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
  const ThemeCard({
    @required this.harpyTheme,
    @required this.selected,
    @required this.onTap,
  });

  final HarpyTheme harpyTheme;
  final bool selected;
  final VoidCallback onTap;

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
                _buildThemeName(context),
                Expanded(child: _buildThemeColors()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeName(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      width: double.infinity,
      color: harpyTheme.theme.primaryColor,
      child: Text(
        harpyTheme.name,
        style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
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
    if (selected) {
      return Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Icon(Icons.check),
        ),
      );
    } else {
      return Container();
    }
  }
}
