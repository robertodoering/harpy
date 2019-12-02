import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:harpy/components/widgets/settings/settings_list.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/dialogs.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:harpy/core/utils/string_utils.dart';
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

  static const route = "custom_theme_screen";

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
      builder: (context) => HarpyDialog(
        title: "Really delete?",
        actions: [
          DialogAction.discard,
          DialogAction.confirm,
        ],
      ),
    ).then((result) {
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
class _CustomThemeColorSelections extends StatefulWidget {
  @override
  __CustomThemeColorSelectionsState createState() =>
      __CustomThemeColorSelectionsState();
}

class __CustomThemeColorSelectionsState
    extends State<_CustomThemeColorSelections>
    with SingleTickerProviderStateMixin<_CustomThemeColorSelections> {
  List<Widget> _buildThemeColors(
    BuildContext context,
    CustomThemeModel model,
  ) {
    return <Widget>[
      _ChangeColorListTile(
        model: model,
        title: "Accent color",
        color: Color(model.customThemeData.accentColor),
        onChanged: model.changeAccentColor,
      ),
    ];
  }

  /// Builds the [_ChangeColorListTile]s for the background colors.
  List<Widget> _buildBackgroundColors(
    BuildContext context,
    CustomThemeModel model,
  ) {
    final backgroundColors = model.customThemeData.backgroundColors;

    return backgroundColors
        .asMap()
        .entries
        .map((entry) => _ChangeColorListTile(
              model: model,
              title: "${indexToOrdinalNumber(entry.key)} background color",
              color: Color(entry.value),
              onRemove: backgroundColors.length > 1
                  ? () => model.removeBackgroundColor(entry.key)
                  : null,
              onChanged: (color) => model.changeBackgroundColor(
                entry.key,
                color,
              ),
            ))
        .toList();
  }

  Widget _buildAddBackgroundColorTile(CustomThemeModel model) {
    return ListTile(
      leading: SizedBox(width: 40, child: Icon(Icons.add)),
      title: const Text("Add background color"),
      dense: true,
      onTap: model.addBackgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final customThemeModel = CustomThemeModel.of(context);

    return AnimatedSize(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: SettingsColumn(
        title: "Colors",
        children: <Widget>[
          ..._buildThemeColors(context, customThemeModel),
          ..._buildBackgroundColors(context, customThemeModel),
          if (customThemeModel.canAddBackgroundColor)
            _buildAddBackgroundColorTile(customThemeModel),
        ],
      ),
    );
  }
}

/// Builds a [ListTile] that opens a [_CustomThemeColorDialog] on tap.
class _ChangeColorListTile extends StatelessWidget {
  const _ChangeColorListTile({
    @required this.model,
    @required this.title,
    @required this.color,
    @required this.onChanged,
    this.onRemove,
  });

  final CustomThemeModel model;
  final String title;
  final Color color;
  final ValueChanged<Color> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final enableRemove = onRemove != null;

    return ListTile(
      leading: CircleColor(color: color, circleSize: 40),
      title: Text(title),
      trailing: enableRemove
          ? IconButton(icon: Icon(Icons.clear), onPressed: onRemove)
          : null,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _CustomThemeColorDialog(
            customThemeModel: model,
            initialColor: color,
            onChanged: onChanged,
          ),
        );
      },
    );
  }
}

/// The dialog that shows the color picker.
class _CustomThemeColorDialog extends StatefulWidget {
  const _CustomThemeColorDialog({
    @required this.customThemeModel,
    @required this.initialColor,
    @required this.onChanged,
  });

  final CustomThemeModel customThemeModel;
  final Color initialColor;
  final ValueChanged<Color> onChanged;

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

    _color = widget.initialColor;

    _showMaterialColorPicker();
  }

  void _onColorChanged(Color color) {
    setState(() {
      _color = color;
    });

    widget.onChanged(color);
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
