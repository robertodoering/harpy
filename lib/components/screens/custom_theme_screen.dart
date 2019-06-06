import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:harpy/components/widgets/settings/settings_list.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/models/custom_theme_model.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:provider/provider.dart';

/// Creates a screen to create and edit a custom harpy theme.
class CustomThemeScreen extends StatefulWidget {
  @override
  _CustomThemeScreenState createState() => _CustomThemeScreenState();
}

class _CustomThemeScreenState extends State<CustomThemeScreen> {
  CustomThemeModel customThemeModel;

  @override
  Widget build(BuildContext context) {
    customThemeModel ??= CustomThemeModel(
      themeModel: ThemeSettingsModel.of(context),
    );

    return ChangeNotifierProvider<CustomThemeModel>(
      builder: (_) => customThemeModel,
      child: Consumer<CustomThemeModel>(
        builder: (context, customThemeModel, _) {
          return Theme(
            data: customThemeModel.harpyTheme.theme,
            child: HarpyScaffold(
              primaryBackgroundColor:
                  customThemeModel.harpyTheme.primaryBackgroundColor,
              secondaryBackgroundColor:
                  customThemeModel.harpyTheme.secondaryBackgroundColor,
              title: "Custom theme",
              actions: <Widget>[
                _CustomThemeSaveButton(),
              ],
              body: ListView(
                children: <Widget>[
                  _CustomThemeNameField(customThemeModel),
                  SizedBox(height: 8.0),
                  _CustomThemeBaseSelection(),
                  SizedBox(height: 8.0),
                  _CustomThemeColorSelections(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Builds the button to save the custom theme and shows a [SnackBar] with an
/// error message if it was unable to save it.
///
/// Only implemented in the pro version.
class _CustomThemeSaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.check),
      onPressed: null,
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
    final harpyTheme = HarpyTheme.custom(model.customThemeData);

    final textStyle = harpyTheme.theme.textTheme.body1.copyWith(
      color: harpyTheme.backgroundComplimentaryColor,
    );

    return SettingsColumn(
      title: "Base theme",
      child: DefaultTabController(
        initialIndex: model.initialTabControllerIndex,
        length: 2,
        child: TabBar(
          onTap: model.changeBase,
          tabs: <Widget>[
            Tab(child: Text("Light", style: textStyle)),
            Tab(child: Text("Dark", style: textStyle)),
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
    final harpyTheme = HarpyTheme.custom(model.customThemeData);

    return <_CustomThemeColor>[
      _CustomThemeColor(
        name: "Accent color",
        color: harpyTheme.theme.accentColor,
        onColorChanged: model.changeAccentColor,
      ),
      _CustomThemeColor(
        name: "Primary background color",
        color: harpyTheme.primaryBackgroundColor,
        onColorChanged: model.changePrimaryBackgroundColor,
      ),
      _CustomThemeColor(
        name: "Secondary background color",
        color: harpyTheme.secondaryBackgroundColor,
        onColorChanged: model.changeSecondaryBackgroundColor,
      ),
      _CustomThemeColor(
        name: "Like color",
        color: harpyTheme.likeColor,
        onColorChanged: model.changeLikeColor,
      ),
      _CustomThemeColor(
        name: "Retweet color",
        color: harpyTheme.retweetColor,
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
