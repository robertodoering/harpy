import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
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
          title: Text('discard changes?'),
          actions: <DialogAction<bool>>[
            DialogAction<bool>(
              result: false,
              text: 'cancel',
            ),
            DialogAction<bool>(
              result: true,
              text: 'discard',
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
    return HarpyButton.flat(
      padding: const EdgeInsets.all(16),
      icon: const Icon(FeatherIcons.check),
      onTap: customThemeBloc.canSaveTheme
          ? () => customThemeBloc.add(const SaveCustomTheme())
          : null,
    );
  }

  Widget _buildBody(CustomThemeBloc customThemeBloc) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: DefaultEdgeInsets.symmetric(vertical: true),
            children: <Widget>[
              if (Harpy.isFree) ...<Widget>[
                const BuyProText(),
                defaultVerticalSpacer,
              ],
              ThemeNameSelection(customThemeBloc),
              SizedBox(height: defaultPaddingValue * 2),
              AccentColorSelection(customThemeBloc),
              SizedBox(height: defaultPaddingValue * 2),
              BackgroundColorSelection(customThemeBloc),
              SizedBox(height: defaultPaddingValue * 2),
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
                  title: 'theme customization',
                  buildSafeArea: true,
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
