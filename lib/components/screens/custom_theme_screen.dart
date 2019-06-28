import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:harpy/components/widgets/settings/settings_list.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/misc/flushbar.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:harpy/models/custom_theme_model.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:provider/provider.dart';

/// Creates a screen to create and edit a custom harpy theme.
class CustomThemeScreen extends StatefulWidget {
  const CustomThemeScreen({
    this.editingThemeData,
    this.editingThemeId,
  });

  final HarpyThemeData editingThemeData;
  final int editingThemeId;

  @override
  _CustomThemeScreenState createState() => _CustomThemeScreenState();
}

class _CustomThemeScreenState extends State<CustomThemeScreen> {
  CustomThemeModel customThemeModel;

  Future<bool> _showBackDialog() async {
    // don't show dialog when nothing changed after editing theme
    if (customThemeModel.customThemeData == customThemeModel.editingThemeData) {
      return true;
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Discard changes?",
            style: Theme.of(context)
                .textTheme
                .subtitle
                .copyWith(color: Theme.of(context).textTheme.body1.color),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).errorColor,
              splashColor: Theme.of(context).accentColor.withOpacity(0.1),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Discard"),
            ),
            FlatButton(
              textColor: Theme.of(context).accentColor,
              splashColor: Theme.of(context).accentColor.withOpacity(0.1),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Back"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    customThemeModel ??= CustomThemeModel(
      themeSettingsModel: ThemeSettingsModel.of(context),
      editingThemeData: widget.editingThemeData,
      editingThemeId: widget.editingThemeId,
    );

    return ChangeNotifierProvider<CustomThemeModel>(
      builder: (_) => customThemeModel,
      child: Consumer<CustomThemeModel>(
        builder: (context, customThemeModel, _) {
          return Theme(
            data: customThemeModel.harpyTheme.theme,
            child: WillPopScope(
              onWillPop: _showBackDialog,
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
                          SizedBox(height: 8.0),
                          _CustomThemeColorSelections(),
                        ],
                      ),
                    ),
                    _CustomThemeDeleteButton(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Builds a button that will delete the custom theme.
///
/// Only appears when editing an existing custom theme.
class _CustomThemeDeleteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final customThemeModel = CustomThemeModel.of(context);

    if (customThemeModel.editingThemeId == null) {
      return Container();
    }

    final themeSettingsModel = ThemeSettingsModel.of(context);

    return RaisedButton(
      child: Text("Delete theme"),
      color: Theme.of(context).errorColor,
      onPressed: () {
        if (themeSettingsModel.selectedThemeId ==
            customThemeModel.editingThemeId) {
          // when deleting the active custom theme, reset to the default theme
          themeSettingsModel.changeSelectedTheme(
            PredefinedThemes.themes.first,
            0,
          );
        }

        themeSettingsModel.deleteCustomTheme(
          themeSettingsModel.selectedThemeId,
        );

        Navigator.of(context).pop();
      },
    );
  }
}

/// Builds the button to save the custom theme.
class _CustomThemeSaveButton extends StatelessWidget {
  void _saveTheme(BuildContext context) {
    final model = CustomThemeModel.of(context);

    if (model.customThemeData?.name?.isEmpty ?? true) {
      showFlushbar(
        "Enter a name",
        type: FlushbarType.error,
      );
      return;
    }

    if (model.errorText() != null) {
      showFlushbar(
        model.errorText(),
        type: FlushbarType.error,
      );
      return;
    }

    final themeSettingsModel = ThemeSettingsModel.of(context);

    if (model.editingThemeId != null) {
      // edited theme
      themeSettingsModel.updateCustomTheme(
        model.customThemeData,
        model.editingThemeId,
      );
    } else {
      // new theme
      themeSettingsModel.saveNewCustomTheme(model.customThemeData);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.check),
      onPressed: () => _saveTheme(context),
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
          widget.model.changeName(_controller.text);
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
              horizontal: 8.0,
              vertical: 12.0,
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
        name: "Primary color",
        color: harpyTheme.primaryColor,
        onColorChanged: model.changePrimaryColor,
      ),
      _CustomThemeColor(
        name: "Accent color",
        color: harpyTheme.theme.accentColor,
        onColorChanged: model.changeAccentColor,
      ),
    ];
  }

  List<Widget> _buildThemeColorSelections(BuildContext context) {
    final model = CustomThemeModel.of(context);

    return _getThemeColors(model).map((themeColorModel) {
      return ListTile(
        leading: CircleColor(color: themeColorModel.color, circleSize: 40.0),
        title: Text(themeColorModel.name),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => _CustomThemeColorDialog(themeColorModel),
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

/// The dialog that shows the [MaterialColorPicker] in an [AlertDialog].
class _CustomThemeColorDialog extends StatefulWidget {
  const _CustomThemeColorDialog(this.themeColorModel);

  final _CustomThemeColor themeColorModel;

  @override
  _CustomThemeColorDialogState createState() => _CustomThemeColorDialogState();
}

class _CustomThemeColorDialogState extends State<_CustomThemeColorDialog> {
  Widget content;
  bool showingColorPicker = false;

  @override
  void initState() {
    super.initState();

    _hideColorPicker();
  }

  void _showColorPicker() {
    setState(() {
      showingColorPicker = true;
      content = Padding(
        padding: const EdgeInsets.all(16.0),
        child: ColorPicker(
          pickerColor: widget.themeColorModel.color,
          onColorChanged: widget.themeColorModel.onColorChanged,
        ),
      );
    });
  }

  void _hideColorPicker() {
    setState(() {
      showingColorPicker = false;
      content = MaterialColorPicker(
        selectedColor: widget.themeColorModel.color,
        onColorChange: widget.themeColorModel.onColorChanged,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: content,
      ),
      actions: <Widget>[
        showingColorPicker
            ? FlatButton(
                textColor: Theme.of(context).accentColor,
                splashColor: Theme.of(context).accentColor.withOpacity(0.1),
                onPressed: _hideColorPicker,
                child: Text("Back"),
              )
            : FlatButton(
                textColor: Theme.of(context).accentColor,
                splashColor: Theme.of(context).accentColor.withOpacity(0.1),
                onPressed: _showColorPicker,
                child: Text("Custom color"),
              ),
        FlatButton(
          textColor: Theme.of(context).accentColor,
          splashColor: Theme.of(context).accentColor.withOpacity(0.1),
          onPressed: Navigator.of(context).pop,
          child: Text("Done"),
        ),
      ],
    );
  }
}

/// A simple model for building the [_CustomThemeColorSelections].
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
