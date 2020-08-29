import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/dialogs/color_picker_dialog.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_state.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/harpy_theme_data.dart';

class CustomThemeScreen extends StatelessWidget {
  const CustomThemeScreen({
    @required this.themeData,
    @required this.themeId,
  });

  /// The [HarpyThemeData] for the theme customization.
  ///
  /// When creating a new custom theme, this will be initialized with the
  /// currently active theme.
  /// When editing an existing custom theme, this will be set to the custom
  /// theme data.
  final HarpyThemeData themeData;

  /// The id of this custom theme, starting at 10 for the first custom theme.
  ///
  /// When creating a new custom theme, this will be the next available id.
  /// When editing an existing custom theme, this will be the id of the custom
  /// theme.
  final int themeId;

  static const String route = 'custom_theme_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomThemeBloc>(
      create: (BuildContext context) => CustomThemeBloc(
        themeData: themeData,
        themeId: themeId,
      ),
      child: BlocBuilder<CustomThemeBloc, CustomThemeState>(
        builder: (BuildContext context, CustomThemeState state) {
          final CustomThemeBloc bloc = CustomThemeBloc.of(context);
          final HarpyTheme harpyTheme = bloc.harpyTheme;

          return Theme(
            data: harpyTheme.data,
            child: HarpyScaffold(
              backgroundColors: harpyTheme.backgroundColors,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.check),
                  // todo: save theme
                  onPressed: () {},
                ),
              ],
              title: 'Theme customization',
              body: ListView(
                children: <Widget>[
                  // todo: theme name
                  CustomThemeBackgroundColors(bloc),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomThemeBackgroundColors extends StatelessWidget {
  const CustomThemeBackgroundColors(this.bloc);

  final CustomThemeBloc bloc;

  String _nameFromIndex(int index) {
    // todo: move to string utils
    if (index == 0) {
      return 'First';
    } else if (index == 1) {
      return 'Second';
    } else if (index == 2) {
      return 'Third';
    } else if (index == 3) {
      return 'Fourth';
    } else {
      return 'Fifth';
    }
  }

  List<Widget> _buildBackgroundColors(HarpyTheme harpyTheme) {
    return <Widget>[
      for (int i = 0; i < harpyTheme.backgroundColors.length; i++)
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: harpyTheme.backgroundColors[i],
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: double.infinity,
            child: Material(
              type: MaterialType.transparency,
              child: ListTile(
                title: Text('${_nameFromIndex(i)} background color'),
                // todo: change color
                onTap: () {},
              ),
            ),
          ),
        )
    ];
  }

  Widget _buildAddBackgroundColor(BuildContext context, HarpyTheme harpyTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: harpyTheme.data.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          leading: const Icon(Icons.add),
          title: const Text('Add background color'),
          onTap: () async {
            final Color color = await showDialog<Color>(
              context: context,
              builder: (BuildContext context) => ColorPickerDialog(
                color: harpyTheme.backgroundColors.first,
              ),
            );

            // todo: add background color
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HarpyTheme harpyTheme = bloc.harpyTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ..._buildBackgroundColors(harpyTheme),
        _buildAddBackgroundColor(context, harpyTheme),
      ],
    );
  }
}
