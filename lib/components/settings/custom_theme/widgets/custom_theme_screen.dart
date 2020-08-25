import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/harpy_theme_data.dart';

class CustomThemeScreen extends StatelessWidget {
  const CustomThemeScreen({
    @required this.themeData,
    @required this.themeId,
  });

  /// The [HarpyThemeData] for the theme customization.
  ///
  /// When creating a new custom theme, this will be initialized with the
  /// currently active theme.
  /// When editing an existing custom theme, this will be set to the custom
  /// theme data.
  final HarpyThemeData themeData;

  /// The id of this custom theme, starting at 10 for the first custom theme.
  ///
  /// When creating a new custom theme, this will be the next available id.
  /// When editing an existing custom theme, this will be the id of the custom
  /// theme.
  final int themeId;

  static const String route = 'custom_theme_screen';

  @override
  Widget build(BuildContext context) {
    // todo: create custom theme bloc & listener
    return Theme(
      // data: _customTheme.data,
      data: HarpyTheme.fromData(themeData).data,
      child: HarpyScaffold(
        // backgroundColors: _customTheme.backgroundColors,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            // todo: save theme
            onPressed: () {},
          ),
        ],
        title: 'Theme customization',
        body: Container(),
      ),
    );
  }
}

class CustomThemeBackgroundColors extends StatelessWidget {
  const CustomThemeBackgroundColors();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
