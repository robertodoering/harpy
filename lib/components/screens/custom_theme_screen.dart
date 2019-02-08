import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:harpy/components/screens/settings_screen.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:harpy/models/custom_theme_model.dart';
import 'package:harpy/models/settings_model.dart';
import 'package:harpy/models/theme_model.dart';
import 'package:scoped_model/scoped_model.dart';

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
      themeModel: ThemeModel.of(context),
      settingsModel: SettingsModel.of(context),
      editingThemeId: widget.editingThemeId,
    );

    return ScopedModel<CustomThemeModel>(
      model: customThemeModel,
      child: ScopedModelDescendant<CustomThemeModel>(
        builder: (context, _, customThemeModel) {
          return Theme(
            data: customThemeModel.harpyTheme.theme,
            child: WillPopScope(
              onWillPop: _showBackDialog,
              child: HarpyScaffold(
                appBar: "Custom theme",
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
                          _CustomThemeBaseSelection(),
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
    final model = CustomThemeModel.of(context);

    if (model.editingThemeId == null) {
      return Container();
    }

    final settingsModel = SettingsModel.of(context);
    final themeModel = ThemeModel.of(context);

    return RaisedButton(
      child: Text("Delete theme"),
      color: Theme.of(context).errorColor,
      onPressed: () {
        if (settingsModel.selectedTheme(model.editingThemeId)) {
          themeModel.harpyPrefs.setSelectedThemeId(model.editingThemeId - 1);
          themeModel.initTheme();
        }

        settingsModel.deleteCustomTheme(model.editingThemeId - 2);
        Navigator.of(context).pop();
      },
    );
  }
}

/// Builds the button to save the custom theme and shows a [SnackBar] with an
/// error message if it was unable to save it.
class _CustomThemeSaveButton extends StatelessWidget {
  void _saveTheme(BuildContext context) {
    final model = CustomThemeModel.of(context);

    if (model.customThemeData?.name?.isEmpty ?? true) {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("Enter a name")),
      );
      return;
    }

    if (model.errorText() != null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(model.errorText())),
      );
      return;
    }

    final settingsModel = SettingsModel.of(context);

    if (model.editingThemeId != null) {
      // edited theme
      settingsModel.updateCustomTheme(
        model.customThemeData,
        model.editingThemeId,
      );
    } else {
      // new theme
      model.themeModel.changeSelectedTheme(
        model.harpyTheme,
        settingsModel.customThemes.length + 2,
      );

      settingsModel.saveNewCustomTheme(model.customThemeData);
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
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 12.0,
          ),
          errorText: widget.model.errorText(),
        ),
      ),
    );
  }
}

/// Builds a [TabBar] to select the light or dark default [ThemeData] as the
/// base for the custom theme.
class _CustomThemeBaseSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = CustomThemeModel.of(context);

    final theme = HarpyTheme.custom(model.customThemeData).theme;
    final textStyle = theme.textTheme.body1.copyWith(
      color:
          ThemeData.estimateBrightnessForColor(theme.scaffoldBackgroundColor) ==
                  Brightness.light
              ? Colors.black
              : Colors.white,
    );

    return SettingsColumn(
      title: "Base theme",
      child: DefaultTabController(
        initialIndex: model.initialTabControllerIndex,
        length: 2,
        child: TabBar(
          onTap: model.changeBase,
          tabs: <Widget>[
            Tab(
              child: Text(
                "Light",
                style: textStyle,
              ),
            ),
            Tab(
              child: Text(
                "Dark",
                style: textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Builds a [ListView] with [ListTile]s to change the colors in a custom
/// [HarpyTheme].
class _CustomThemeColorSelections extends StatelessWidget {
  List<_CustomThemeColor> _getThemeColors(CustomThemeModel model) {
    return <_CustomThemeColor>[
      _CustomThemeColor(
        name: "Primary color",
        color: Color(model.customThemeData.primaryColor),
        onColorChanged: model.changePrimaryColor,
      ),
      _CustomThemeColor(
        name: "Accent color",
        color: Color(model.customThemeData.accentColor),
        onColorChanged: model.changeAccentColor,
      ),
      _CustomThemeColor(
        name: "Background color",
        color: Color(model.customThemeData.scaffoldBackgroundColor),
        onColorChanged: model.changeScaffoldBackgroundColor,
      ),
      _CustomThemeColor(
        name: "Secondary background color",
        color: Color(model.customThemeData.secondaryBackgroundColor),
        onColorChanged: model.changeSecondaryBackgroundColor,
      ),
      _CustomThemeColor(
        name: "Like color",
        color: Color(model.customThemeData.likeColor),
        onColorChanged: model.changeLikeColor,
      ),
      _CustomThemeColor(
        name: "Retweet color",
        color: Color(model.customThemeData.retweetColor),
        onColorChanged: model.changeRetweetColor,
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
      child: Column(
        children: _buildThemeColorSelections(context),
      ),
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
