import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/common/dialogs/harpy_dialog.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

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
          text: 'back',
          onTap: () => setState(() {
            _configureColorPickerSize();
            _showCustomPicker = false;
          }),
        )
      else
        DialogAction<void>(
          text: 'custom',
          onTap: () => setState(() {
            _configureColorPickerSize();
            _showCustomPicker = true;
          }),
        ),
      DialogAction<void>(
        text: 'select',
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
        selectedColor: widget.color,
        shrinkWrap: true,
        onColorChange: (Color color) => _color = color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget child =
        _showCustomPicker ? _buildCustomPicker() : _buildMaterialPicker();

    return HarpyDialog(
      animationType: DialogAnimationType.slide,
      contentPadding: EdgeInsets.zero,
      constrainActionSize: true,
      content: CustomAnimatedSize(
        child: AnimatedSwitcher(
          duration: kShortAnimationDuration,
          child: child,
        ),
      ),
      actions: _buildActions(),
    );
  }
}
