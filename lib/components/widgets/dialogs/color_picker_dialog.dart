import 'package:flutter/material.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    required this.color,
    this.allowTransparency = false,
    this.onColorChanged,
  });

  /// The initial picker color.
  final Color color;

  final bool allowTransparency;

  /// An optional callback which is invoked when the color picker changes its
  /// color.
  final ValueChanged<Color>? onColorChanged;

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _color;

  @override
  void initState() {
    super.initState();

    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      animationType: DialogAnimationType.slide,
      contentPadding: EdgeInsets.zero,
      constrainActionSize: true,
      actions: [
        DialogAction<void>(
          text: 'discard',
          onTap: () => app<HarpyNavigator>().pop(widget.color),
        ),
        DialogAction<void>(
          text: 'select',
          onTap: () => app<HarpyNavigator>().pop(_color),
        ),
      ],
      content: HarpyColorPicker(
        color: _color,
        allowTransparency: widget.allowTransparency,
        onColorChanged: (color) {
          _color = color;
          widget.onColorChanged?.call(color);
        },
      ),
    );
  }
}
