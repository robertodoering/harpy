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

  void _editCustomTheme(ThemeBloc themeBloc, int themeId, int index) {
    //   final editingHarpyTheme = themeBloc.customThemes[index];

    //   // update system ui when editing theme
    //   updateSystemUi(editingHarpyTheme);

    //   // app<HarpyNavigator>().pushCustomTheme(
    //   //   themeData: HarpyThemeData.fromHarpyTheme(editingHarpyTheme),
    //   //   themeId: themeId,
    //   // );
  }

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
          onTap: () => _selectTheme(
            themeBloc: bloc,
            lightThemeId: lightThemeId,
            darkThemeId: darkThemeId,
            newLightThemeId: i + 10,
            newDarkThemeId: i + 10,
          ),
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
          onEdit: () => _editCustomTheme(bloc, i + 10, i),
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
