import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen();

  static const route = 'theme_selection';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final systemBrightness = context.watch<Brightness>();
    final config = context.watch<ConfigCubit>().state;

    final bloc = context.watch<ThemeBloc>();
    final state = bloc.state;

    final lightThemeId = app<ThemePreferences>().lightThemeId;
    final darkThemeId = app<ThemePreferences>().darkThemeId;

    final children = [
      for (var i = 0; i < predefinedThemes.length; i++)
        ThemeCard(
          HarpyTheme.fromData(data: predefinedThemes[i], config: config),
          selectedLightTheme: i == lightThemeId,
          selectedDarkTheme: i == darkThemeId,
          onTap: () => selectTheme(
            themeBloc: bloc,
            lightThemeId: lightThemeId,
            darkThemeId: darkThemeId,
            newLightThemeId:
                isFree || systemBrightness == Brightness.light ? i : null,
            newDarkThemeId:
                isFree || systemBrightness == Brightness.dark ? i : null,
          ),
          onSelectLightTheme: () => selectTheme(
            themeBloc: bloc,
            lightThemeId: lightThemeId,
            darkThemeId: darkThemeId,
            newLightThemeId: i,
          ),
          onSelectDarkTheme: () => selectTheme(
            themeBloc: bloc,
            lightThemeId: lightThemeId,
            darkThemeId: darkThemeId,
            newDarkThemeId: i,
          ),
        ),
      if (isPro)
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
                selectTheme(
                  themeBloc: bloc,
                  lightThemeId: lightThemeId,
                  darkThemeId: darkThemeId,
                  newLightThemeId:
                      systemBrightness == Brightness.light ? i + 10 : null,
                  newDarkThemeId:
                      systemBrightness == Brightness.dark ? i + 10 : null,
                );
              }
            },
            onSelectLightTheme: () => selectTheme(
              themeBloc: bloc,
              lightThemeId: lightThemeId,
              darkThemeId: darkThemeId,
              newLightThemeId: i + 10,
            ),
            onSelectDarkTheme: () => selectTheme(
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
            onDelete: () => bloc.add(
              ThemeEvent.deleteCustomTheme(themeId: i + 10),
            ),
          ),
      const AddCustomThemeCard(),
      if (isFree) ...[
        Padding(
          padding: config.edgeInsets,
          child: Text(
            'only available for harpy pro',
            style: theme.textTheme.subtitle2,
          ),
        ),
        for (final proTheme in predefinedProThemes)
          ProThemeCard(HarpyTheme.fromData(data: proTheme, config: config)),
      ],
    ];

    return HarpyScaffold(
      title: 'theme selection',
      buildSafeArea: true,
      body: ListView.separated(
        padding: config.edgeInsets,
        itemCount: children.length,
        itemBuilder: (_, index) => children[index],
        separatorBuilder: (_, __) => smallVerticalSpacer,
      ),
    );
  }
}

Future<void> _editCustomTheme(
  BuildContext context, {
  required Config config,
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

void selectTheme({
  required ThemeBloc themeBloc,
  required int lightThemeId,
  required int darkThemeId,
  int? newLightThemeId,
  int? newDarkThemeId,
}) {
  assert(
    isPro || newLightThemeId == newDarkThemeId,
    "can't select light & dark theme independently in the free version",
  );

  if (lightThemeId != newLightThemeId || darkThemeId != newDarkThemeId) {
    HapticFeedback.lightImpact();

    themeBloc.add(
      ThemeEvent.changeTheme(
        lightThemeId: newLightThemeId,
        darkThemeId: newDarkThemeId,
        saveSelection: true,
      ),
    );
  }
}
