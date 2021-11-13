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
    final bloc = context.watch<ThemeBloc>();

    return HarpyListCard(
      color: Colors.transparent,
      leading: const Icon(CupertinoIcons.add),
      title: const Text('add custom theme'),
      trailing: isFree ? const FlareIcon.shiningStar(size: 28) : null,
      border: Border.all(color: theme.dividerColor),
      onTap: () => _pushCustomTheme(
        context,
        state: bloc.state,
      ),
    );
  }
}

Future<void> _pushCustomTheme(
  BuildContext context, {
  required ThemeState state,
}) async {
  final systemBrightness = context.read<Brightness>();

  // use the currently selected theme as a starting point for the custom theme
  final themeData = (systemBrightness == Brightness.light
          ? state.lightThemeData
          : state.darkThemeData)
      .copyWith(name: 'new theme');

  // use the next available custom theme id
  final themeId = state.customThemesData.length + 10;

  app<HarpyNavigator>().pushCustomTheme(
    themeData: themeData,
    themeId: themeId,
  );
}
