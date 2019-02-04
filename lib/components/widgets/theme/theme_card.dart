import 'package:flutter/material.dart';
import 'package:harpy/core/misc/theme.dart';

class ThemeCard extends StatelessWidget {
  const ThemeCard({
    @required this.harpyTheme,
    @required this.selected,
    @required this.onTap,
  });

  final HarpyTheme harpyTheme;
  final bool selected;
  final VoidCallback onTap;

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
}
