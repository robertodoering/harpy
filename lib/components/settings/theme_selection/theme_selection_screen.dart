import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen();

  static const String route = 'theme_selection';

  void _changeTheme(
    ThemeBloc themeBloc,
    int selectedThemeId,
    int newThemeId,
  ) {
    if (selectedThemeId != newThemeId) {
      HapticFeedback.lightImpact();
      themeBloc.add(ChangeThemeEvent(id: newThemeId, saveSelection: true));
    }
  }

  void _editCustomTheme(ThemeBloc themeBloc, int themeId, int index) {
    final editingHarpyTheme = themeBloc.customThemes[index];

    // update system ui when editing theme
    updateSystemUi(editingHarpyTheme);

    // app<HarpyNavigator>().pushCustomTheme(
    //   themeData: HarpyThemeData.fromHarpyTheme(editingHarpyTheme),
    //   themeId: themeId,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final themeBloc = context.watch<ThemeBloc>();
    final config = context.watch<ConfigBloc>().state;

    final selectedThemeId = themeBloc.selectedThemeId;

    final children = [
      for (var i = 0; i < predefinedThemes.length; i++)
        ThemeCard(
          HarpyTheme.fromData(data: predefinedThemes[i], config: config),
          selectedLightTheme: i == selectedThemeId,
          selectedDarkTheme: i == selectedThemeId,
          onTap: () => _changeTheme(themeBloc, selectedThemeId, i),
        ),
      for (var i = 0; i < themeBloc.customThemes.length; i++)
        ThemeCard(
          themeBloc.customThemes[i],
          selectedLightTheme: i + 10 == selectedThemeId,
          selectedDarkTheme: i + 10 == selectedThemeId,
          editable: true,
          deletable: true,
          onTap: () => selectedThemeId == i + 10
              ? _editCustomTheme(themeBloc, i + 10, i)
              : _changeTheme(themeBloc, selectedThemeId, i + 10),
          onEdit: () => _editCustomTheme(themeBloc, i + 10, i),
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
