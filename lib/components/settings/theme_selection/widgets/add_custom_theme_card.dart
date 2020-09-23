import 'package:flutter/material.dart';
import 'package:harpy/components/common/dialogs/pro_dialog.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_bloc.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/harpy_theme_data.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// A card used to add a custom theme for the [ThemeSelectionScreen].
class AddCustomThemeCard extends StatelessWidget {
  const AddCustomThemeCard();

  Future<void> _onTap(
    BuildContext context,
    HarpyThemeData themeData,
    int themeId,
  ) async {
    if (Harpy.isFree) {
      final bool result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => const ProDialog(
          feature: 'Theme customization',
        ),
      );

      if (result == true) {
        // todo: add try pro feature analytics
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ThemeBloc themeBloc = ThemeBloc.of(context);

    // the initial custom theme data uses the currently selected theme
    final HarpyThemeData initialCustomThemeData =
        HarpyThemeData.fromHarpyTheme(HarpyTheme.of(context))
          ..name = 'New theme';

    // use the next available custom theme id
    final int nextCustomThemeId = themeBloc.customThemes.length + 10;

    // only build a trailing icon when using harpy free
    final Widget trailing =
        Harpy.isFree ? const FlareIcon.shiningStar(size: 28) : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: kDefaultBorderRadius,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          shape: kDefaultShapeBorder,
          leading: const Icon(Icons.add),
          title: const Text('Add custom theme'),
          trailing: trailing,
          onTap: () => _onTap(
            context,
            initialCustomThemeData,
            nextCustomThemeId,
          ),
        ),
      ),
    );
  }
}
