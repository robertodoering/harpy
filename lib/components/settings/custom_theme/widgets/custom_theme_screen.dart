import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/dialogs/harpy_dialog.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_event.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_state.dart';
import 'package:harpy/components/settings/custom_theme/widgets/content/accent_color_selection.dart';
import 'package:harpy/components/settings/custom_theme/widgets/content/background_color_selection.dart';
import 'package:harpy/components/settings/custom_theme/widgets/content/buy_pro_text.dart';
import 'package:harpy/components/settings/custom_theme/widgets/content/delete_theme_button.dart';
import 'package:harpy/components/settings/custom_theme/widgets/content/theme_name_selection.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_bloc.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_event.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/harpy_theme_data.dart';
import 'package:harpy/harpy.dart';

/// The custom theme screen for editing existing custom themes and creating
/// new custom themes.
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

  Future<bool> _onWillPop(
    BuildContext context,
    ThemeBloc themeBloc,
    CustomThemeBloc customThemeBloc,
  ) async {
    bool pop = true;

    if (customThemeBloc.canSaveTheme) {
      // ask to discard changes before exiting customization

      final bool discard = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => const HarpyDialog(
          title: Text('Discard changes?'),
          actions: <DialogAction<bool>>[
            DialogAction<bool>(
              result: false,
              text: 'Cancel',
            ),
            DialogAction<bool>(
              result: true,
              text: 'Discard',
            ),
          ],
        ),
      );

      pop = discard == true;
    }

    if (pop) {
      // reset the system ui
      themeBloc.add(UpdateSystemUi(theme: themeBloc.harpyTheme));
      return true;
    } else {
      return false;
    }
  }

  Widget _buildSaveAction(CustomThemeBloc customThemeBloc) {
    return IconButton(
      icon: const Icon(Icons.check),
      onPressed: customThemeBloc.canSaveTheme
          ? () => customThemeBloc.add(const SaveCustomTheme())
          : null,
    );
  }

  Widget _buildBody(CustomThemeBloc customThemeBloc) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: DefaultEdgeInsets.symmetric(vertical: true),
            children: <Widget>[
              if (Harpy.isFree) ...const <Widget>[
                BuyProText(),
                SizedBox(height: 32),
              ],
              ThemeNameSelection(customThemeBloc),
              const SizedBox(height: 32),
              AccentColorSelection(customThemeBloc),
              const SizedBox(height: 32),
              BackgroundColorSelection(customThemeBloc),
              const SizedBox(height: 32),
            ],
          ),
        ),
        if (customThemeBloc.editingCustomTheme)
          DeleteThemeButton(customThemeBloc),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeBloc themeBloc = ThemeBloc.of(context);

    return BlocProvider<CustomThemeBloc>(
      create: (BuildContext context) => CustomThemeBloc(
        themeData: HarpyThemeData.from(themeData),
        themeId: themeId,
        themeBloc: themeBloc,
      ),
      child: BlocBuilder<CustomThemeBloc, CustomThemeState>(
        builder: (BuildContext context, CustomThemeState state) {
          final CustomThemeBloc customThemeBloc = CustomThemeBloc.of(context);
          final HarpyTheme harpyTheme = customThemeBloc.harpyTheme;

          return Theme(
            data: harpyTheme.data,
            child: Builder(
              builder: (BuildContext context) => WillPopScope(
                onWillPop: () => _onWillPop(
                  context,
                  themeBloc,
                  customThemeBloc,
                ),
                child: HarpyScaffold(
                  backgroundColors: harpyTheme.backgroundColors,
                  actions: <Widget>[
                    _buildSaveAction(customThemeBloc),
                  ],
                  title: 'Theme customization',
                  body: _buildBody(customThemeBloc),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
