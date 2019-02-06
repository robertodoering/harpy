import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:harpy/components/screens/settings_screen.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/misc/theme.dart';
import 'package:harpy/models/custom_theme_model.dart';
import 'package:harpy/models/settings_model.dart';
import 'package:harpy/models/theme_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomThemeScreen extends StatefulWidget {
  @override
  _CustomThemeScreenState createState() => _CustomThemeScreenState();
}

class _CustomThemeScreenState extends State<CustomThemeScreen> {
  CustomThemeModel customThemeModel;

  Future<bool> _showBackDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Discard changes?",
            style: Theme.of(context).textTheme.subtitle,
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
    );

    return ScopedModel<CustomThemeModel>(
      model: customThemeModel,
      child: ScopedModelDescendant<CustomThemeModel>(
        builder: (context, _, customThemeModel) {
          return Theme(
            data: customThemeModel.customTheme,
            child: WillPopScope(
              onWillPop: _showBackDialog,
              child: HarpyScaffold(
                appBar: "Custom theme",
                actions: <Widget>[
                  SaveCustomThemeButton(),
                ],
                body: ListView(
                  children: <Widget>[
                    CustomThemeNameField(customThemeModel),
                    SizedBox(height: 8.0),
                    CustomThemeBaseSelection(),
                    SizedBox(height: 8.0),
                    CustomThemeColorSelections(),
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

class SaveCustomThemeButton extends StatelessWidget {
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

    settingsModel.saveCustomTheme(model.customThemeData, false);
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
class CustomThemeNameField extends StatefulWidget {
  const CustomThemeNameField(this.model);

  final CustomThemeModel model;

  @override
  _CustomThemeNameFieldState createState() => _CustomThemeNameFieldState();
}

class _CustomThemeNameFieldState extends State<CustomThemeNameField> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.model.customThemeData.name)
      ..addListener(_onNameChange)
      ..addListener(() => setState(() {}));
  }

  void _onNameChange() {
    final model = CustomThemeModel.of(context);
    model.changeName(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final model = CustomThemeModel.of(context);

    return SettingsColumn(
      title: "Theme name",
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 12.0,
          ),
          errorText: model.errorText(),
        ),
      ),
    );
  }
}

/// Builds a [TabBar] to select the light or dark default [ThemeData] as the
/// base for the custom theme.
class CustomThemeBaseSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = CustomThemeModel.of(context);

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
                style: HarpyTheme.custom(model.customThemeData)
                    .theme
                    .textTheme
                    .body1,
              ),
            ),
            Tab(
              child: Text(
                "Dark",
                style: HarpyTheme.custom(model.customThemeData)
                    .theme
                    .textTheme
                    .body1,
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
class CustomThemeColorSelections extends StatelessWidget {
  List<ThemeColorModel> _getThemeColors(CustomThemeModel model) {
    return <ThemeColorModel>[
      ThemeColorModel(
        name: "Primary color",
        color: Color(model.customThemeData.primaryColor),
        onColorChanged: model.changePrimaryColor,
      ),
      ThemeColorModel(
        name: "Accent color",
        color: Color(model.customThemeData.accentColor),
        onColorChanged: model.changeAccentColor,
      ),
      ThemeColorModel(
        name: "Background color",
        color: Color(model.customThemeData.scaffoldBackgroundValue),
        onColorChanged: model.changeBackgroundColor,
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
            builder: (context) => CustomThemeColorDialog(themeColorModel),
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
class CustomThemeColorDialog extends StatefulWidget {
  const CustomThemeColorDialog(this.themeColorModel);

  final ThemeColorModel themeColorModel;

  @override
  _CustomThemeColorDialogState createState() => _CustomThemeColorDialogState();
}

class _CustomThemeColorDialogState extends State<CustomThemeColorDialog> {
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

/// A simple model for building the [CustomThemeColorSelections].
class ThemeColorModel {
  const ThemeColorModel({
    @required this.name,
    @required this.color,
    @required this.onColorChanged,
  });

  final String name;
  final Color color;
  final ValueChanged<Color> onColorChanged;
}
