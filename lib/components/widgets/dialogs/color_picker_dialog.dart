import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

/// Builds a [HarpyDialog] with a color picker and pops the navigator with the
/// selected [Color] or `null` if no color has been selected.
class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    required this.color,
  });

  /// The initial picker color.
  final Color? color;

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  /// The currently selected color.
  Color? _color;

  @override
  void initState() {
    super.initState();

    _color = widget.color;
  }

  List<DialogAction<void>> _buildActions() {
    return <DialogAction<void>>[
      DialogAction<void>(
        text: 'select',
        onTap: () {
          app<HarpyNavigator>().state!.pop(_color);
        },
      ),
    ];
  }

  /// Builds a [SlidePicker] for a customizable color selection.
  Widget _buildCustomPicker() {
    return SlidePicker(
      pickerColor: widget.color!,
      // indicatorSize: Size(size?.data?.width ?? 280, 50),
      indicatorBorderRadius: BorderRadius.circular(16),
      // 2 / 3 of the width for the sliders
      // sliderSize: Size((size?.data?.width ?? 280) * (2 / 3), 40),
      paletteType: PaletteType.rgb,
      enableAlpha: false,
      showLabel: false,
      onColorChanged: (color) => _color = color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      animationType: DialogAnimationType.slide,
      contentPadding: EdgeInsets.zero,
      constrainActionSize: true,
      content: CustomAnimatedSize(
        child: AnimatedSwitcher(
          duration: kShortAnimationDuration,
          child: _buildCustomPicker(),
        ),
      ),
      actions: _buildActions(),
    );
  }
}
