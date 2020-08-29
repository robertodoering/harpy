import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_state.dart';
import 'package:harpy/components/settings/custom_theme/widgets/content/background_colors.dart';
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
