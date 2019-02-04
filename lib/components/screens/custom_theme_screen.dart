import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/misc/theme.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:harpy/models/theme_model.dart';

class CustomThemeScreen extends StatefulWidget {
  @override
  _CustomThemeScreenState createState() => _CustomThemeScreenState();
}

class _CustomThemeScreenState extends State<CustomThemeScreen> {
  HarpyThemeData customThemeData;

  @override
  Widget build(BuildContext context) {
    final themeModel = ThemeModel.of(context);

    customThemeData ??= HarpyThemeData.fromTheme(themeModel.harpyTheme);

    return Theme(
      data: HarpyTheme.custom(customThemeData).theme,
      child: HarpyScaffold(
        appBar: "Custom theme",
        body: Center(
          child: RaisedButton(onPressed: () {
            setState(() {
              customThemeData.primaryColor = Colors.red.value;
            });
          }),
        ),
      ),
    );
  }
}
