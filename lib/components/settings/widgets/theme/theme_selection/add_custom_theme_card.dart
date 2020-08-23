import 'package:flutter/material.dart';
import 'package:harpy/components/common/dialogs/pro_dialog.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/components/settings/bloc/custom_theme/custom_theme_bloc.dart';
import 'package:harpy/core/message_service.dart';
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
        app<MessageService>().showInfo('Not yet available');
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
    final CustomThemeBloc customThemeBloc = CustomThemeBloc.of(context);

    // the initial custom theme data uses the currently selected theme
    final HarpyThemeData initialCustomThemeData =
        HarpyThemeData.fromHarpyTheme(HarpyTheme.of(context));

    // use the next available custom theme id
    final int nextCustomThemeId = customThemeBloc.customThemes.length + 10;

    // only build a trailing icon when using harpy free
    final Widget trailing =
        Harpy.isFree ? const FlareIcon.shiningStar(size: 28) : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
