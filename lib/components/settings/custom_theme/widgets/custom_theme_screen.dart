import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_state.dart';
import 'package:harpy/components/settings/custom_theme/widgets/content/background_color_selection.dart';
import 'package:harpy/components/settings/custom_theme/widgets/content/theme_name_selection.dart';
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
        themeData: HarpyThemeData.from(themeData),
        themeId: themeId,
      ),
      child: BlocBuilder<CustomThemeBloc, CustomThemeState>(
        builder: (BuildContext context, CustomThemeState state) {
          final CustomThemeBloc bloc = CustomThemeBloc.of(context);
          final HarpyTheme harpyTheme = bloc.harpyTheme;

          // todo: update system ui on background color change
          //  and change back when going back to theme selection

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
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  ThemeNameSelection(bloc),
                  const SizedBox(height: 32),
                  BackgroundColorSelection(bloc),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
