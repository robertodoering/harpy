import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen();

  static const String route = 'theme_selection';

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ThemeBloc>();
    final state = bloc.state;
    final config = context.watch<ConfigBloc>().state;

    final lightThemeId = app<ThemePreferences>().lightThemeId;
    final darkThemeId = app<ThemePreferences>().darkThemeId;

    final children = [
      for (var i = 0; i < predefinedThemes.length; i++)
        ThemeCard(
          HarpyTheme.fromData(data: predefinedThemes[i], config: config),
          selectedLightTheme: i == lightThemeId,
          selectedDarkTheme: i == darkThemeId,
          onTap: () => _selectTheme(
            themeBloc: bloc,
            lightThemeId: lightThemeId,
            darkThemeId: darkThemeId,
            newLightThemeId: i,
            newDarkThemeId: i,
          ),
          onSelectLightTheme: () => _selectTheme(
            themeBloc: bloc,
            lightThemeId: lightThemeId,
            darkThemeId: darkThemeId,
            newLightThemeId: i,
          ),
          onSelectDarkTheme: () => _selectTheme(
            themeBloc: bloc,
            lightThemeId: lightThemeId,
            darkThemeId: darkThemeId,
            newDarkThemeId: i,
          ),
        ),
      for (var i = 0; i < state.customThemesData.length; i++)
        ThemeCard(
          HarpyTheme.fromData(
            data: state.customThemesData[i],
            config: config,
          ),
          selectedLightTheme: i + 10 == lightThemeId,
          selectedDarkTheme: i + 10 == darkThemeId,
          onTap: () {
            if (lightThemeId == i + 10 && darkThemeId == i + 10) {
              // already selected as light a dark theme, edit selected theme
              // instead
              _editCustomTheme(
                context,
                config: config,
                state: state,
                themeId: i + 10,
              );
            } else {
              _selectTheme(
                themeBloc: bloc,
                lightThemeId: lightThemeId,
                darkThemeId: darkThemeId,
                newLightThemeId: i + 10,
                newDarkThemeId: i + 10,
              );
            }
          },
          onSelectLightTheme: () => _selectTheme(
            themeBloc: bloc,
            lightThemeId: lightThemeId,
            darkThemeId: darkThemeId,
            newLightThemeId: i + 10,
          ),
          onSelectDarkTheme: () => _selectTheme(
            themeBloc: bloc,
            lightThemeId: lightThemeId,
            darkThemeId: darkThemeId,
            newDarkThemeId: i + 10,
          ),
          onEdit: () => _editCustomTheme(
            context,
            config: config,
            state: state,
            themeId: i + 10,
          ),
          onDelete: () => bloc.add(DeleteCustomTheme(themeId: i + 10)),
        ),
      const AddCustomThemeCard(),
    ];

    return HarpyScaffold(
      title: 'theme selection',
      buildSafeArea: true,
      body: ListView.separated(
        padding: config.edgeInsets,
        itemCount: children.length,
        itemBuilder: (_, index) => children[index],
        separatorBuilder: (_, __) => defaultSmallVerticalSpacer,
      ),
    );
  }
}

Future<void> _editCustomTheme(
  BuildContext context, {
  required ConfigState config,
  required ThemeState state,
  required int themeId,
}) async {
  final index = themeId - 10;
  final themeData = state.customThemesData[index];

  updateSystemUi(HarpyTheme.fromData(data: themeData, config: config));

  app<HarpyNavigator>().pushCustomTheme(
    themeData: themeData,
    themeId: themeId,
  );
}

void _selectTheme({
  required ThemeBloc themeBloc,
  required int lightThemeId,
  required int darkThemeId,
  int? newLightThemeId,
  int? newDarkThemeId,
}) {
  if (lightThemeId != newLightThemeId || darkThemeId != newDarkThemeId) {
    HapticFeedback.lightImpact();
    themeBloc.add(
      ChangeTheme(
        lightThemeId: newLightThemeId,
        darkThemeId: newDarkThemeId,
        saveSelection: true,
      ),
    );
  }
}
