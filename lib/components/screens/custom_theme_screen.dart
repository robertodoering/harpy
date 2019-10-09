import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:harpy/components/widgets/settings/settings_list.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/dialogs.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/models/custom_theme_model.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:provider/provider.dart';

/// Creates a screen to create and edit a custom harpy theme.
class CustomThemeScreen extends StatelessWidget {
  const CustomThemeScreen({
    this.editingThemeData,
    this.editingThemeId,
  });

  final HarpyThemeData editingThemeData;
  final int editingThemeId;

  /// Resets the system ui color when returning from the custom theme.
  Future<bool> _onWillPop(BuildContext context) async {
    ThemeSettingsModel.of(context).updateSystemUi();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: ChangeNotifierProvider<CustomThemeModel>(
        builder: (_) => CustomThemeModel(
          themeSettingsModel: ThemeSettingsModel.of(context),
          editingThemeData: editingThemeData,
          editingThemeId: editingThemeId,
        ),
        child: Consumer<CustomThemeModel>(
          builder: (context, customThemeModel, _) => Theme(
            data: customThemeModel.harpyTheme.theme,
            child: HarpyScaffold(
              backgroundColors: customThemeModel.harpyTheme.backgroundColors,
              title: "Custom theme",
              actions: <Widget>[
                _CustomThemeSaveButton(),
              ],
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        _CustomThemeNameField(customThemeModel),
                        const SizedBox(height: 8),
                        _CustomThemeColorSelections(),
                      ],
                    ),
                  ),
                  if (customThemeModel.editingTheme) _CustomThemeDeleteButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Builds a button that will delete the custom theme.
///
/// Only appears when editing an existing custom theme.
class _CustomThemeDeleteButton extends StatelessWidget {
  void _showDialog(BuildContext context) {
    final customThemeModel = CustomThemeModel.of(context);
    final themeSettingsModel = ThemeSettingsModel.of(context);

    showDialog(
        context: context,
        builder: (context) {
          return HarpyDialog(
            title: "Really delete?",
            actions: [
              DialogAction.discard,
              DialogAction.confirm,
            ],
          );
        }).then((result) {
      if (result == true) {
        if (themeSettingsModel.selectedThemeId ==
            customThemeModel.editingThemeId) {
          // when deleting the active custom theme, reset to the
          // default theme
          themeSettingsModel.changeSelectedTheme(
            PredefinedThemes.themes.first,
            0,
          );
        }

        themeSettingsModel.deleteCustomTheme(
          themeSettingsModel.selectedThemeId,
        );

        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: HarpyButton.raised(
        text: "Delete theme",
        onTap: () => _showDialog(context),
      ),
    );
  }
}

/// Builds the button to save the custom theme.
class _CustomThemeSaveButton extends StatelessWidget {
  void _saveTheme(BuildContext context) {
    final model = CustomThemeModel.of(context);

    if (model.saveTheme()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.check),
      onPressed: Harpy.isPro ? () => _saveTheme(context) : null,
    );
  }
}

/// Builds the [TextField] to change the custom theme name.
class _CustomThemeNameField extends StatefulWidget {
  const _CustomThemeNameField(this.model);

  final CustomThemeModel model;

  @override
  _CustomThemeNameFieldState createState() => _CustomThemeNameFieldState();
}

class _CustomThemeNameFieldState extends State<_CustomThemeNameField> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.model.customThemeData.name)
      ..addListener(() {
        setState(() {
          widget.model.customThemeData.name = _controller.text;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsColumn(
      title: "Theme name",
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 12,
            ),
            errorText: widget.model.errorText(),
          ),
        ),
      ],
    );
  }
}

/// Builds a [ListView] with [ListTile]s to change the colors in a custom
/// [HarpyTheme].
class _CustomThemeColorSelections extends StatelessWidget {
  List<_CustomThemeColor> _getThemeColors(CustomThemeModel model) {
    final harpyTheme = HarpyTheme.fromData(model.customThemeData);

    return <_CustomThemeColor>[
      _CustomThemeColor(
        name: "First background color",
        color: harpyTheme.backgroundColors.first,
        onColorChanged: model.changeFirstBackgroundColor,
      ),
      _CustomThemeColor(
        name: "Second background color",
        color: harpyTheme.backgroundColors.last,
        onColorChanged: model.changeSecondBackgroundColor,
      ),
      _CustomThemeColor(
        name: "Accent color",
        color: harpyTheme.theme.accentColor,
        onColorChanged: model.changeAccentColor,
      ),
    ];
  }

  List<Widget> _buildThemeColorSelections(BuildContext context) {
    final customThemeModel = CustomThemeModel.of(context);

    return _getThemeColors(customThemeModel).map((themeColorModel) {
      return ListTile(
        leading: CircleColor(color: themeColorModel.color, circleSize: 40),
        title: Text(themeColorModel.name),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => _CustomThemeColorDialog(
              themeColorModel,
              customThemeModel,
            ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsColumn(
      title: "Colors",
      children: _buildThemeColorSelections(context),
    );
  }
}

/// The dialog that shows the color picker in a dialog.
class _CustomThemeColorDialog extends StatefulWidget {
  const _CustomThemeColorDialog(this.themeColorModel, this.customThemeModel);

  final _CustomThemeColor themeColorModel;
  final CustomThemeModel customThemeModel;

  @override
  _CustomThemeColorDialogState createState() => _CustomThemeColorDialogState();
}

class _CustomThemeColorDialogState extends State<_CustomThemeColorDialog>
    with SingleTickerProviderStateMixin {
  Widget _content;
  bool _showingColorPicker = false;
  Color _color;

  @override
  void initState() {
    super.initState();

    _color = widget.themeColorModel.color;

    _showMaterialColorPicker();
  }

  void _onColorChanged(Color color) {
    setState(() {
      _color = color;
    });

    widget.themeColorModel.onColorChanged(color);
  }

  /// Sets the [_content] to be a [ColorPicker] that shows a customizable
  /// color picker.
  void _showColorPicker() {
    setState(() {
      _showingColorPicker = true;
      _content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ColorPicker(
          color: _color,
          onChanged: _onColorChanged,
        ),
      );
    });
  }

  /// Sets the [_content] to be a [MaterialColorPicker] that shows a selection
  /// of predefined colors.
  void _showMaterialColorPicker() {
    setState(() {
      _showingColorPicker = false;
      _content = MaterialColorPicker(
        selectedColor: _color,
        onColorChange: _onColorChanged,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      backgroundColors: widget.customThemeModel.harpyTheme.backgroundColors,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      body: AnimatedSize(
        vsync: this,
        duration: const Duration(milliseconds: 150),
        child: _content,
      ),
      actions: [
        if (_showingColorPicker)
          DialogAction(
            text: "Back",
            onTap: _showMaterialColorPicker,
          )
        else
          DialogAction(
            text: "Custom color",
            onTap: _showColorPicker,
          ),
        DialogAction(
          text: "Done",
          onTap: Navigator.of(context).pop,
        ),
      ],
    );
  }
}

/// Contains information used for customizing colors in the
/// [_CustomThemeColorSelections].
class _CustomThemeColor {
  const _CustomThemeColor({
    @required this.name,
    @required this.color,
    @required this.onColorChanged,
  });

  final String name;
  final Color color;
  final ValueChanged<Color> onColorChanged;
}
