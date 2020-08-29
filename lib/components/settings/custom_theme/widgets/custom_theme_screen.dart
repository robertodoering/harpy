import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/common/dialogs/harpy_dialog.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_bloc.dart';
import 'package:harpy/components/settings/custom_theme/bloc/custom_theme_state.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/core/theme/harpy_theme_data.dart';
import 'package:harpy/misc/harpy_navigator.dart';

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

class CustomThemeBackgroundColors extends StatelessWidget {
  const CustomThemeBackgroundColors(this.bloc);

  final CustomThemeBloc bloc;

  String _nameFromIndex(int index) {
    // todo: move to string utils
    if (index == 0) {
      return 'First';
    } else if (index == 1) {
      return 'Second';
    } else if (index == 2) {
      return 'Third';
    } else if (index == 3) {
      return 'Fourth';
    } else {
      return 'Fifth';
    }
  }

  List<Widget> _buildBackgroundColors(HarpyTheme harpyTheme) {
    return <Widget>[
      for (int i = 0; i < harpyTheme.backgroundColors.length; i++)
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: harpyTheme.backgroundColors[i],
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: double.infinity,
            child: Material(
              type: MaterialType.transparency,
              child: ListTile(
                title: Text('${_nameFromIndex(i)} background color'),
                // todo: change color
                onTap: () {},
              ),
            ),
          ),
        )
    ];
  }

  Widget _buildAddBackgroundColor(BuildContext context, HarpyTheme harpyTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: harpyTheme.data.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          leading: const Icon(Icons.add),
          title: const Text('Add background color'),
          onTap: () async {
            final Color color = await showDialog<Color>(
              context: context,
              builder: (BuildContext context) => ColorPickerDialog(
                color: harpyTheme.backgroundColors.first,
              ),
            );

            // todo: add background color
            print(color);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HarpyTheme harpyTheme = bloc.harpyTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ..._buildBackgroundColors(harpyTheme),
        _buildAddBackgroundColor(context, harpyTheme),
      ],
    );
  }
}

/// Builds a [HarpyDialog] with a color picker and pops the navigator with the
/// selected [Color] or `null` if no color has been selected.
class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    @required this.color,
  });

  /// The initial picker color.
  final Color color;

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  /// `true` when the [SliderPicker] should be built.
  bool _showCustomPicker = false;

  /// The currently selected color.
  Color _color;

  /// The key for the size of the [MaterialColorPicker].
  final GlobalKey _colorPickerKey = GlobalKey();

  /// Completes with the size of the [MaterialColorPicker] after it has been
  /// built.
  ///
  /// Used to give the [SliderPicker] the same width as [MaterialColorPicker] so
  /// that during the transition from one to the other the width stays the same.
  Completer<Size> _colorPickerSizeCompleter = Completer<Size>();

  @override
  void initState() {
    super.initState();

    _color = widget.color;
    _configureColorPickerSize();
  }

  /// Completes the [_colorPickerSizeCompleter] with the size of the render
  /// object from the [_colorPickerKey].
  ///
  /// Used to determine the size of the [MaterialColorPicker] in the dialog.
  Future<void> _configureColorPickerSize() async {
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      final RenderBox box = _colorPickerKey?.currentContext?.findRenderObject();
      _colorPickerSizeCompleter = Completer<Size>();
      _colorPickerSizeCompleter.complete(box?.size);
    });
  }

  List<DialogAction<void>> _buildActions() {
    return <DialogAction<void>>[
      if (_showCustomPicker)
        DialogAction<void>(
          icon: Icons.color_lens,
          onTap: () => setState(() {
            _configureColorPickerSize();
            _showCustomPicker = false;
          }),
        )
      else
        DialogAction<void>(
          icon: Icons.colorize,
          onTap: () => setState(() {
            _configureColorPickerSize();
            _showCustomPicker = true;
          }),
        ),
      DialogAction<void>(
        icon: Icons.check,
        onTap: () {
          app<HarpyNavigator>().state.pop(_color);
        },
      ),
    ];
  }

  /// Builds a [SlidePicker] for a customizable color selection.
  Widget _buildCustomPicker() {
    return FutureBuilder<Size>(
      future: _colorPickerSizeCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<Size> size) {
        return SlidePicker(
          pickerColor: widget.color,
          indicatorSize: Size(size?.data?.width ?? 280, 50),
          indicatorBorderRadius: BorderRadius.circular(16),
          // 2 / 3 of the width for the sliders
          sliderSize: Size((size?.data?.width ?? 280) * (2 / 3), 40),
          paletteType: PaletteType.rgb,
          enableAlpha: false,
          showLabel: false,
          onColorChanged: (Color color) => _color = color,
        );
      },
    );
  }

  /// Builds a [MaterialColorPicker] for selecting a material color.
  Widget _buildMaterialPicker() {
    return SizedBox(
      key: _colorPickerKey,
      child: MaterialColorPicker(
        physics: const BouncingScrollPhysics(),
        selectedColor: widget.color,
        shrinkWrap: true,
        onColorChange: (Color color) => _color = color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context);
    final Widget child =
        _showCustomPicker ? _buildCustomPicker() : _buildMaterialPicker();

    return HarpyDialog(
      padding: EdgeInsets.zero,
      body: CustomAnimatedSize(
        child: AnimatedSwitcher(
          duration: kShortAnimationDuration,
          child: child,
        ),
      ),
      actions: _buildActions(),
    );
  }
}
