import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

/// A card used to add a custom theme for the [ThemeSelectionScreen].
class AddCustomThemeCard extends StatelessWidget {
  const AddCustomThemeCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeBloc = context.watch<ThemeBloc>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: kDefaultBorderRadius,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          shape: kDefaultShapeBorder,
          leading: const Icon(CupertinoIcons.add),
          title: const Text('add custom theme'),
          trailing: Harpy.isFree ? const FlareIcon.shiningStar(size: 28) : null,
          onTap: () => _pushCustomTheme(
            context,
            themeBloc: themeBloc,
          ),
        ),
      ),
    );
  }
}

Future<void> _pushCustomTheme(
  BuildContext context, {
  required ThemeBloc themeBloc,
}) async {
  final systemBrightness = MediaQuery.platformBrightnessOf(context);

  // use the currently selected theme as a starting point for the  custom theme
  final themeData = (systemBrightness == Brightness.light
          ? themeBloc.state.lightThemeData
          : themeBloc.state.darkThemeData)
      .copyWith(name: 'new theme');

  // use the next available custom theme id
  final themeId = themeBloc.customThemes.length + 10;

  if (Harpy.isFree) {
    // todo: don't show a dialog, instead use a card similar to the home tab
    //   customization
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const ProDialog(feature: 'theme customization'),
    );

    if (result != null && result) {
      app<HarpyNavigator>().pushCustomTheme(
        themeData: themeData,
        themeId: themeId,
      );
    }
  } else {
    app<HarpyNavigator>().pushCustomTheme(
      themeData: themeData,
      themeId: themeId,
    );
  }
}
