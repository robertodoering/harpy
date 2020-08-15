import 'package:flutter/material.dart';
import 'package:harpy/components/application/bloc/application_bloc.dart';
import 'package:harpy/components/application/bloc/application_event.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/predefined_themes.dart';
import 'package:harpy/harpy.dart';

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
              onTap: () => setState(() {
                applicationBloc.add(ChangeThemeEvent(
                  harpyTheme: harpyTheme,
                  id: predefinedThemes.indexOf(harpyTheme),
                ));
              }),
            ),
          const AddCustomThemeCard(),
        ],
      ),
    );
  }
}

class ThemeCard extends StatelessWidget {
  const ThemeCard(
    this.harpyTheme, {
    this.selected = false,
    this.onTap,
  });

  final HarpyTheme harpyTheme;

  final bool selected;

  final VoidCallback onTap;

  LinearGradient get gradient => LinearGradient(
      colors: harpyTheme.backgroundColors.length > 1
          ? harpyTheme.backgroundColors
          : <Color>[
              harpyTheme.backgroundColors.first,
              harpyTheme.backgroundColors.first
            ]);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: harpyTheme.data,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(gradient: gradient),
          child: Material(
            type: MaterialType.transparency,
            child: ListTile(
              title: Text(
                harpyTheme.name,
              ),
              trailing: selected ? const Icon(Icons.check) : null,
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}

class AddCustomThemeCard extends StatelessWidget {
  const AddCustomThemeCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // only build a trailing icon when using harpy free
    final Widget trailing = Harpy.isFree
        ? const FlareIcon.shiningStar(
            size: 28,
          )
        : null;

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
          onTap: () {},
        ),
      ),
    );
  }
}
