import 'package:flutter/material.dart';
import 'package:harpy/components/application/bloc/application_bloc.dart';
import 'package:harpy/components/application/bloc/application_event.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/widgets/theme/theme_selection/add_custom_theme_card.dart';
import 'package:harpy/components/settings/widgets/theme/theme_selection/theme_card.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/predefined_themes.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen();

  static const String route = 'theme_selection';

  @override
  _ThemeSelectionScreenState createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applicationBloc = ApplicationBloc.of(context);
    final HarpyTheme activeHarpyTheme = HarpyTheme.of(context);

    return HarpyScaffold(
      title: 'Theme selection',
      body: Column(
        children: <Widget>[
          for (HarpyTheme harpyTheme in predefinedThemes)
            ThemeCard(
              harpyTheme,
              selected: harpyTheme == activeHarpyTheme,
              onTap: () {
                if (harpyTheme != activeHarpyTheme) {
                  setState(() {
                    applicationBloc.add(ChangeThemeEvent(
                      harpyTheme: harpyTheme,
                      id: predefinedThemes.indexOf(harpyTheme),
                    ));
                  });
                }
              },
            ),
          const AddCustomThemeCard(),
        ],
      ),
    );
  }
}
